class RDB
  class Reader
    SUPPORTED_VERSIONS = ["0001"]

    # Special values for special redis commands.
    REDIS_EXPIRETIME = 253
    REDIS_SELECTDB   = 254
    REDIS_EOF        = 255

    # Defines related to the dump file format. To store 32 bits lengths for short
    # keys requires a lot of space, so we check the most significant 2 bits of
    # the first byte to interpreter the length:
    #
    # 00|000000 => if the two MSB are 00 the len is the 6 bits of this byte
    # 01|000000 00000000 =>  01, the len is 14 byes, 6 bits + 8 bits of next byte
    # 10|000000 [32 bit integer] => if it's 01, a full 32 bit len will follow
    # 11|000000 this means: specially encoded object will follow. The six bits
    #           number specify the kind of object that follows.
    #           See the REDIS_RDB_ENC_* defines.
    #
    # Lenghts up to 63 are stored using a single byte, most DB keys, and may
    # values, will fit inside. */
    REDIS_RDB_6BITLEN  = 0
    REDIS_RDB_14BITLEN = 1
    REDIS_RDB_32BITLEN = 2
    REDIS_RDB_ENCVAL   = 3
    REDIS_RDB_LENERR   = ((2**(0.size * 8 -2) -1))*2

    # When a length of a string object stored on disk has the first two bits
    # set, the remaining two bits specify a special encoding for the object
    # accordingly to the following defines:
    REDIS_RDB_ENC_INT8  = 0  # 8 bit signed integer
    REDIS_RDB_ENC_INT16 = 1  # 16 bit signed integer
    REDIS_RDB_ENC_INT32 = 2  # 32 bit signed integer
    REDIS_RDB_ENC_LZF   = 3  # string compressed with FASTLZ

    def initialize(rdb_filename)
      File.open(rdb_filename, "rb") do |file|
        @header = read_header(file)
        @data   = file
        read_data
      end
    end

    def read_header(file)
      header = file.read(9)
      magic_number, version = header.unpack("A5A4")

      fail "Not an .rdb File!" if magic_number != "REDIS"
      fail "Unsupported version" if !SUPPORTED_VERSIONS.include?(version)
    end

    def read_data
      type = ""
      while(type != REDIS_EOF)
        type = read_datum
      end
    end

    def read_datum
      if datum = @data.read(1)
        puts "in read_datum " + datum.unpack("C").first.to_s
        if handle_special_types(datum)
          read_key_value_pairs(datum)
        end
      else
        fail "EOF"
      end
    end

    def handle_special_types(datum)
      if type = datum.unpack("C").first
        case type
        when REDIS_EOF
          puts "EOF"
          exit
        when REDIS_SELECTDB
          db = handle_selectdb
          puts "Selected db #{db}"
          @data.read(1) # is there a padding byte?
          return false
        end
      else
        fail "Failed to parse .rdb type, exiting."
      end
      return true
    end

    def read_key_value_pairs(datum)
      puts "in read_key_value_pairs " + datum.unpack("C").first.to_s

      key = load_string_object
      val = load_object
      return datum
    end

    def handle_selectdb
      load_length
    end

    def load_length(encoded=nil)
      encoded = encoded ? 0 : nil

      buf = @data.read(1).unpack("C").first

      if buf
        type = (buf & 0xC0) >> 6
        case type
        when REDIS_RDB_6BITLEN
          return buf & 0x3F
        when REDIS_RDB_ENCVAL
        when REDIS_RDB_14BITLEN
        else
        end
      else
        return REDIS_RDB_LENERR
      end
    end

    def load_string_object
      generic_load_string_object
    end

    def load_encoded_string_object
      generic_load_string_object(1)
    end

    def load_object

    end

    def generic_load_string_object(encoded=nil)
      encoded = encoded ? 0 : nil

      len = load_length(encoded)

      if encoded
        case len
        when REDIS_RDB_ENC_INT8
        when REDIS_RDB_ENC_INT16
        when REDIS_RDB_ENC_INT32
          return load_integer_object(len,encoded)
        when REDIS_RDB_ENC_LZF
          return load_lzf_string_object
        else
          fail "Unknown RDB encoding type"
        end
      end

      return nil if len == REDIS_RDB_LENERR
      puts "length " + len.to_s

      #string = @data.read(len)
      #string.unpack("C")
      len
    end
  end


end

RDB::Reader.new("dump.rdb")
