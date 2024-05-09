1 pragma solidity ^0.5.5;
2 
3 
4 contract Ownable {
5     
6     mapping(address => bool) internal owner;
7     
8     event AddedOwner(address newOwner);
9     event RemovedOwner(address removedOwner);
10 
11     constructor () public {
12         owner[msg.sender] = true;
13     }
14 
15     modifier ownerOnly() {
16         require(owner[msg.sender]);
17         _;
18     }
19 
20     function ownerAdd(address _newOwner) ownerOnly public {
21         require(_newOwner != address(0));
22         owner[_newOwner] = true;
23         
24         emit AddedOwner(_newOwner);
25     }
26 
27     function ownerRemove(address _toRemove) ownerOnly public {
28         require(_toRemove != address(0));
29         require(_toRemove != msg.sender);
30         //owner[_toRemove] = false;
31         delete owner[_toRemove];
32         
33         emit RemovedOwner(_toRemove);
34     }
35 }
36 
37 
38 contract RunOnChain is Ownable {
39 
40 
41     struct Mensuration {
42         string Longitude;
43         string Latitude;
44         string Elevatio;
45         uint256 GpsDatetime;
46         uint256 DeviceDatetime;
47     }
48     
49     mapping (uint256 => mapping (uint256 => Mensuration[])) internal Mensurations;
50     
51     
52     constructor () public Ownable() { }
53     
54     
55     function insertMensuration(uint256 eventId, uint256 runnerId, string memory gpsLongitude, string memory gpsLatitude, string memory gpsElevation, uint256 gpsDatetime, uint256 deviceDatetime) public ownerOnly() returns (bool) 
56     {
57         require(eventId>0 && runnerId>0 && bytes(gpsLongitude).length>0 && bytes(gpsLatitude).length>0 && bytes(gpsElevation).length>0 && gpsDatetime>0 && deviceDatetime>0);
58         
59         Mensuration memory mensuTemp;
60         mensuTemp.Longitude = gpsLongitude;
61         mensuTemp.Latitude = gpsLatitude;
62         mensuTemp.Elevatio = gpsElevation;
63         mensuTemp.GpsDatetime = gpsDatetime;
64         mensuTemp.DeviceDatetime = deviceDatetime;
65         
66         Mensurations[eventId][runnerId].push(mensuTemp);
67         
68         return true;
69     }
70     
71     
72     function getInfo(uint256 eventId, uint256 runnerId) public ownerOnly() view returns (string memory)
73     {
74         require(eventId >0 && runnerId>0);
75         
76         string memory ret = "{";
77         uint256 arrayLength = Mensurations[eventId][runnerId].length;
78         
79         ret = string(abi.encodePacked(ret, '"EventId": "', uint2str(eventId), '", '));
80         ret = string(abi.encodePacked(ret, '"RunnerId": "', uint2str(runnerId), '", '));
81         
82         ret = string(abi.encodePacked(ret, '"Mensurations": ['));
83         for (uint i=0; i<arrayLength; i++)
84         {
85             ret = string(abi.encodePacked(ret, '{'));
86             ret = string(abi.encodePacked(ret, '"GpsLongitude": "', Mensurations[eventId][runnerId][i].Longitude, '", '));
87             ret = string(abi.encodePacked(ret, '"GpsLatitude": "', Mensurations[eventId][runnerId][i].Latitude, '", '));
88             ret = string(abi.encodePacked(ret, '"GpsElevation": "', Mensurations[eventId][runnerId][i].Elevatio, '"'));
89             ret = string(abi.encodePacked(ret, '"GpsDatetime": "', uint2str(Mensurations[eventId][runnerId][i].GpsDatetime), '"'));
90             ret = string(abi.encodePacked(ret, '"DeviceDatetime": "', uint2str(Mensurations[eventId][runnerId][i].DeviceDatetime), '"'));
91             ret = string(abi.encodePacked(ret, '}'));
92             
93             if(i<arrayLength-1 && arrayLength>1)
94                 ret = string(abi.encodePacked(ret, ', '));
95         }
96         ret = string(abi.encodePacked(ret, "]"));
97     
98         ret = string(abi.encodePacked(ret, "}"));
99                 
100         
101         return ret;
102     }
103     
104     function kill() public ownerOnly()  returns (bool)
105     {
106         selfdestruct(msg.sender);
107     }
108     
109     
110     function uint2str(uint _i) internal pure returns (string memory _uintAsString)
111     {
112         if (_i == 0) { return "0"; }
113         uint j = _i;
114         uint len;
115         while (j != 0) { len++; j /= 10; }
116         bytes memory bstr = new bytes(len);
117         uint k = len - 1;
118         while (_i != 0) { bstr[k--] = byte(uint8(48 + _i % 10)); _i /= 10; }
119         return string(bstr);
120     }
121     
122 }