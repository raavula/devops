# Install Jenkins using Docker  
docker run -d  -u root -p 8080:8080 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock  -v "$HOME":/home  jenkinsci/blueocean    

# Login to container  
docker ps     
docker exec -it <container-id> bash   

# Get Password for UI       
cat /var/jenkins_home/secrets/initialAdminPassword    

# Open and configure Jenkins UI      
http://localhost:8080      
On this page, click Install suggested plugins.    
configure Admin profile        
click save and finish    
click start using Jenkins  

# Get Git code Ready  
cd /Users/<your-username>/Documents/SSP/   [if directory not exists create one]  
git clone git@github.com:raavula/building-a-multibranch-pipeline-project.git   
git branch development  
git branch production 
git branch  


# Create pipeline  
1. Go back to Jenkins and ensure you have accessed the Blue Ocean interface. To do this, make sure you:
   have browsed to http://localhost:8080/blue and are logged in
    or
   have browsed to http://localhost:8080/, are logged in and have clicked Open Blue Ocean on the left.

2. In the Welcome to Jenkins box at the center of the Blue Ocean interface, click Create a new Pipeline to begin the Pipeline creation wizard.
   Note: If you don’t see this box, click New Pipeline at the top right.

3. In Where do you store your code?, click Git (not GitHub).

4. In the Repository URL field (within Connect to a Git repository), specify the directory path of your locally cloned repository above, which is from your user account/home directory on your host machine, mapped to the /home directory of the Jenkins container - i.e.
   /home/Documents/SSP/building-a-multibranch-pipeline-project

5. Click Save to save your new Pipeline project.


 
# Create your initial Pipeline as a Jenkinsfile with build and test stages   
cp Jenkinsfile_1 Jenkinsfile    
git stage .   
git commit -m "Add initial Jenkinsfile with 'Test' stage"   
Click run icon in branched in UI and verify pipeline.   

# Add deliver and deploy stages to your Pipeline   
cp Jenkinsfile_2 Jenkinsfile  
git stage .   
git commit -m "Add initial Jenkinsfile with 'development and production' stage"   

# Run your Pipeline on the development and Production branch   
git checkout development   
git pull . master  
git checkout production    
git pull . master   

Your development and production branches should now have all your Jenkinsfile updates you made on the master branch.     




  

     
