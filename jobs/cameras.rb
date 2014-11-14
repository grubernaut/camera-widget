require 'net/http'
 
@cameraDelay = 1 # Needed for image sync. 
@fetchNewImageEvery = '5s'

@camera1Host = "camera1host"  ## CHANGE
@camera1Port = "80"  ## CHANGE
@camera1Username = 'cameraUsername' ## CHANGE
@camera1Password = 'cameraPassword' ## CHANGE
@camera1URL = "/img/snapshot.cgi?size=2"
@newFile1 = "assets/images/cameras/snapshot1_new.jpeg"
@oldFile1 = "assets/images/cameras/snapshot1_old.jpeg"

@camera2Host = "camera2host"  ## CHANGE
@camera2Port = "80"  ## CHANGE
@camera2Username = 'cameraUsername' ## CHANGE
@camera2Password = 'cameraPassword' ## CHANGE
@camera2URL = "/img/snapshot.cgi?size=2"
@newFile2 = "assets/images/cameras/snapshot2_new.jpeg"
@oldFile2 = "assets/images/cameras/snapshot2_old.jpeg"

@camera3Host = "camera3host"  ## CHANGE
@camera3Port = "80"  ## CHANGE
@camera3Username = 'cameraUsername' ## CHANGE
@camera3Password = 'cameraPassword' ## CHANGE
@camera3URL = "/img/snapshot.cgi?size=2"
@newFile3 = "assets/images/cameras/snapshot3_new.jpeg"
@oldFile3 = "assets/images/cameras/snapshot3_old.jpeg"

 
def fetch_image(host,old_file,new_file, cam_port, cam_user, cam_pass, cam_url)
	`rm #{old_file}` 
	`mv #{new_file} #{old_file}`	
	Net::HTTP.start(host,cam_port) do |http|
		req = Net::HTTP::Get.new(cam_url)
		if cam_user != "None" ## if username for any particular camera is set to 'None' then assume auth not required.
			req.basic_auth cam_user, cam_pass
		end
		response = http.request(req)
		open(new_file, "wb") do |file|
			file.write(response.body)
		end
	end
	new_file
end
 
def make_web_friendly(file)
  "/" + File.basename(File.dirname(file)) + "/" + File.basename(file)
end
 
SCHEDULER.every @fetchNewImageEvery, first_in: 0 do
	new_file1 = fetch_image(@camera1Host,@oldFile1,@newFile1)
	new_file2 = fetch_image(@camera2Host,@oldFile2,@newFile2)
	new_file3 = fetch_image(@camera3Host,@oldFile3,@newFile3)

	if not File.exists?(@newFile1 && @newFile2 && @newFile3)
		warn "Failed to Get Camera Image"
	end
 
	send_event('camera1', image: make_web_friendly(@oldFile1))
	send_event('camera2', image: make_web_friendly(@oldFile2))
	send_event('camera3', image: make_web_friendly(@oldFile3))
	sleep(@cameraDelay)
	send_event('camera1', image: make_web_friendly(new_file1))
	send_event('camera2', image: make_web_friendly(new_file2))
	send_event('camera3', image: make_web_friendly(new_file3))
end
