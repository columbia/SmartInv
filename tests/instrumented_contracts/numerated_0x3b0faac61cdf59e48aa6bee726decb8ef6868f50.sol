1 pragma solidity ^0.4.18;
2 
3 // Holds a contract of all profiles that can be updated.
4 contract EtherProfile {
5     address owner;
6 
7     struct Profile {
8         string name;
9         string imgurl;
10         string email;
11         string aboutMe;
12     }
13 
14     mapping(address => Profile) addressToProfile;
15 
16     function EtherProfile() public {
17         owner = msg.sender;
18     }
19 
20     function getProfile(address _address) public view returns(
21         string,
22         string,
23         string,
24         string
25     ) {
26         return (
27             addressToProfile[_address].name,
28             addressToProfile[_address].imgurl,
29             addressToProfile[_address].email,
30             addressToProfile[_address].aboutMe
31         );
32     }
33 
34     // Simple for now because params are not optional
35     function updateProfile(
36         string name,
37         string imgurl,
38         string email,
39         string aboutMe
40     ) public
41     {
42         address _address = msg.sender;
43         Profile storage p = addressToProfile[_address];
44         p.name = name;
45         p.imgurl = imgurl;
46         p.email = email;
47         p.aboutMe = aboutMe;
48     }
49 
50     function updateProfileName(string name) public {
51         address _address = msg.sender;
52         Profile storage p = addressToProfile[_address];
53         p.name = name;
54     }
55 
56     function updateProfileImgurl(string imgurl) public {
57         address _address = msg.sender;
58         Profile storage p = addressToProfile[_address];
59         p.imgurl = imgurl;
60     }
61 
62     function updateProfileEmail(string email) public {
63         address _address = msg.sender;
64         Profile storage p = addressToProfile[_address];
65         p.email = email;
66     }
67 
68     function updateProfileAboutMe(string aboutMe) public {
69         address _address = msg.sender;
70         Profile storage p = addressToProfile[_address];
71         p.aboutMe = aboutMe;
72     }
73 }