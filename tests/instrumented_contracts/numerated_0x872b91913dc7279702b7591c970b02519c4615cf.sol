1 contract mortal {
2     /* Define variable owner of the type address*/
3     address owner;
4 
5     /* this function is executed at initialization and sets the owner of the contract */
6     function mortal() { owner = msg.sender; }
7 
8     /* Function to recover the funds on the contract */
9     function kill() { if (msg.sender == owner) selfdestruct(owner); }
10 }
11 
12 contract Videos is mortal {
13 
14     uint public numVideos;
15 
16     struct  Video {
17         string videoURL;
18         string team;
19         uint amount;
20     }
21     mapping (uint => Video) public videos;
22     
23     function Videos(){
24         numVideos=0;
25 
26     }
27     
28     function submitVideo(string videoURL, string team) returns (uint videoID)
29     {
30         videoID = numVideos;
31         videos[videoID] = Video(videoURL, team, msg.value);
32         numVideos = numVideos+1;
33     }
34     
35         function vote(uint videoID)
36     {
37         uint payout;
38         videos[videoID].amount=videos[videoID].amount+msg.value;
39         payout = msg.value / ((block.number % 10)+1);
40 	    if(payout > 0){
41 	        msg.sender.send(payout);
42 	    }
43     }
44   
45 }