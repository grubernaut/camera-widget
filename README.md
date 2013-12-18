= Camera Widget for Dashing

Camera Widget is a widget for Shopify's dashing framework to display static IP camera images, updated and rotated every n seconds. 

Camera Widget can support multiple camera widgets displayed at a single time using the same static controller and model. This has been tested to support up to 5 seperate cameras. 

= Configuration

Copy the contents of the assets, jobs, and widgets directories to your dashing installation. 

Edit the jobs/cameras.rb file to specify which camera hosts to display. 

Edit your dashboard to include the views for each camera widget that you would like to display. Inside the cameras controller there are names for each camera, ie: camera1, camera2, camera3 and so on. You can use the included dashboard configuration as a guide for setting up the camera widgets view. 

= License

CameraWidget - A Dashing Widget to display static camera images rotated every n seconds.

Author:: Jake Champlin (jchamplin@thedatacave.com)
Copyright:: Copyright (C) 2013, Data Cave, Inc. (http://www.thedatacave.com/)
License:: 

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
