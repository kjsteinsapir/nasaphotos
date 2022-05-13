require "uri"
require "net/http"
require "json"


def get_api(url, api_key = "AV4bpHb6M3U7t7DX0DPYtoZgWhJzQmHraXTdfnVQ")
    url = URI("#{url}&api_key=#{api_key}") 

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    JSON.parse(response.read_body)  #[0..10]
end

resultado = get_api("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10")

def build_web_page(resultado)
    fotos = resultado['photos'].map{|elemento| elemento['img_src']}
    html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
    
    fotos.each do |foto| 
        html += "\t<li> <img src=\"#{foto}\" width=500px height=500px > </li>\n"
    end
    
    html += "\n</ul>\n</body>\n</html>"
    
    File.write('salida.html', html)
end

build_web_page(resultado)


def photos_count(resultado)
    camara = resultado['photos'].map{|elemento| elemento['camera']['name']}.group_by {|elemento| elemento}.map{|k,v|  [k, v.count]}
   
end 

print photos_count(resultado)
# puts response.read_body