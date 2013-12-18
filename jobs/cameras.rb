require 'net/http'
 
@cameraDelay = 1 # Needed for image sync. 
@fetchNewImageEvery = '5s'
@camera1Host = "camera1host"  ## CHANGE
@camera2Host = "camera2host"  ## CHANGE
@camera3Host = "camera3host"  ## CHANGE
@camera4Host = "camera4host"  ## CHANGE
@camera5Host = "camera5host"  ## CHANGE
@cameraPort = "cameraPort"  ## CHANGE
@cameraUsername = 'cameraUsername' ## CHANGE
@cameraPassword = 'cameraPassword' ## CHANGE
@cameraURL = "/img/snapshot.cgi?size=2"
@newFile1 = "assets/images/cameras/snapshot1_new.jpeg"
@oldFile1 = "assets/images/cameras/snapshot1_old.jpeg"
@newFile2 = "assets/images/cameras/snapshot2_new.jpeg"
@oldFile2 = "assets/images/cameras/snapshot2_old.jpeg"
@newFile3 = "assets/images/cameras/snapshot3_new.jpeg"
@oldFile3 = "assets/images/cameras/snapshot3_old.jpeg"
@newFile4 = "assets/images/cameras/snapshot4_new.jpeg"
@oldFile4 = "assets/images/cameras/snapshot4_old.jpeg"
@newFile5 = "assets/images/cameras/snapshot5_new.jpeg"
@oldFile5 = "assets/images/cameras/snapshot5_old.jpeg"
 
def fetch_image(host,old_file,new_file)
	`rm #{old_file}` 
	`mv #{new_file} #{old_file}`	
	Net::HTTP.start(host,@cameraPort) do |http|
		req = Net::HTTP::Get.new(@cameraURL)
		req.basic_auth @cameraUsername, @cameraPassword
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
	new_file4 = fetch_image(@camera4Host,@oldFile4,@newFile4)
	new_file5 = fetch_image(@camera5Host,@oldFile5,@newFile5)

	if not File.exists?(@newFile1 && @newFile2 && @newFile3 && @newFile4 && @newFile5)
		warn "Failed to Get Camera Image"
	end
 
	send_event('camera1', image: make_web_friendly(@oldFile1))
	send_event('camera2', image: make_web_friendly(@oldFile2))
	send_event('camera3', image: make_web_friendly(@oldFile3))
	send_event('camera4', image: make_web_friendly(@oldFile4))
	send_event('camera5', image: make_web_friendly(@oldFile5))
	sleep(@cameraDelay)
	send_event('camera1', image: make_web_friendly(new_file1))
	send_event('camera2', image: make_web_friendly(new_file2))
	send_event('camera3', image: make_web_friendly(new_file3))
	send_event('camera4', image: make_web_friendly(new_file4))
	send_event('camera5', image: make_web_friendly(new_file5))
end
