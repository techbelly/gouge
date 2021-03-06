module Gouge::Utils
  POSTCODE_REGX = /[A-Z]{1,2}[0-9R][0-9A-Z]?\s*[0-9][ABD-HJLNP-UW-Z]{2}/i

   def extract_postcode(text)
     return unless text
     text = text.strip.sub(/\bo(\w\w)$/i,'0\1') # replace o with zero
     postcode = text[POSTCODE_REGX]
     return nil unless postcode
     postcode.gsub(/\s+/,'').insert(-4,' ').upcase 
   end

   def extract_phone(text,phone)
       return unless text
       return phone if (phone and phone != "")
       p_nums = text.scan(/(?:\+44)?[ 0-9\(\)\-]{10,16}/) 
       p_nums.map { |x| x.gsub!(/\D/,'') }
       p_nums.reject! { |x| x.nil? || x.empty? || x.length < 10 }
       p_nums.each do |num|
         num.sub!(/^44/,'')
         num = case num
           when /^02/ 
             num.insert(3,') ').insert(9,' ')
           when /^08/, /^011/, /^01[2-6,9]1/ #
             num.insert(4,') ')
           when /^01697[3,4,7]/ 
             num.insert(6,') ')
           else
             num.insert(5,') ')
         end
         num.insert(0,'(')
       end
   end
end