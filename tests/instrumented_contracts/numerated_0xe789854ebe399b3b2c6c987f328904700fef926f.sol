1 pragma solidity ^0.5.0;
2 
3 interface TeamInterface {
4 
5     function isOwner() external view returns (bool);
6 
7     function isAdmin(address _sender) external view returns (bool);
8 
9     function isDev(address _sender) external view returns (bool);
10 
11 }
12 
13 /**
14  * @title Artist Contract
15  * @dev http://www.puzzlebid.com/
16  * @author PuzzleBID Game Team 
17  * @dev Simon<vsiryxm@163.com>
18  */
19 contract Artist {
20 
21     TeamInterface private team; 
22     mapping(bytes32 => address payable) private artists; 
23 
24     constructor(address _teamAddress) public {
25         require(_teamAddress != address(0));
26         team = TeamInterface(_teamAddress);
27     }
28 
29     function() external payable {
30         revert();
31     }
32 
33     event OnUpgrade(address indexed _teamAddress);
34     event OnAdd(bytes32 _artistID, address indexed _address);
35     event OnUpdateAddress(bytes32 _artistID, address indexed _address);
36 
37     modifier onlyAdmin() {
38         require(team.isAdmin(msg.sender));
39         _;
40     }
41 
42     function upgrade(address _teamAddress) external onlyAdmin() {
43         require(_teamAddress != address(0));
44         team = TeamInterface(_teamAddress);
45         emit OnUpgrade(_teamAddress);
46     }
47 
48     function getAddress(bytes32 _artistID) external view returns (address payable) {
49         return artists[_artistID];
50     }
51    
52     function add(bytes32 _artistID, address payable _address) external onlyAdmin() {
53         require(this.hasArtist(_artistID) == false);
54         artists[_artistID] = _address;
55         emit OnAdd(_artistID, _address);
56     }
57 
58     function hasArtist(bytes32 _artistID) external view returns (bool) {
59         return artists[_artistID] != address(0);
60     }
61 
62     function updateAddress(bytes32 _artistID, address payable _address) external onlyAdmin() {
63         require(artists[_artistID] != address(0) && _address != address(0));
64         artists[_artistID] = _address;
65         emit OnUpdateAddress(_artistID, _address);
66     }
67 
68 }