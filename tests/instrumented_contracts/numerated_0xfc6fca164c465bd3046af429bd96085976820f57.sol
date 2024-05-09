1 pragma solidity ^0.4.19;
2 
3 // Personal Handle Service PHS
4 // A service on top of the AHS for registering your own handle on top of the .eth base for free
5 // donations are optional
6 
7 contract Ownable {
8     address public owner;
9 
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 
42 interface AHSInterface {
43     function registerHandle(bytes32 _base, bytes32 _handle, address _addr) public payable;
44     function transferBase(bytes32 _base, address _newAddress) public;
45     function findAddress(bytes32 _base, bytes32 _handle) public view returns(address);
46     function isRegistered(bytes32 _base) public view returns(bool);
47     function doesOwn(bytes32 _base, address _addr) public view returns(bool);
48 }
49 
50 
51 contract PHS is Ownable {
52 
53     AHSInterface public ahs;
54     bytes32 public ethBase; // .eth extension
55 
56     mapping (bytes32 => bool) public ethHandleRegistred;
57     mapping (address => mapping (bytes32 => bool)) public ownsEthHandle;
58 
59 
60     event HandleTransfered(bytes32 _handle, address indexed _to);
61 
62     function PHS(AHSInterface _ahs, bytes32 _ethBase) public {
63         ahs = _ahs;
64         ethBase = _ethBase;
65     }
66 
67     function registerEthHandle(bytes32 _handle, address _addr) public payable {
68         require(_addr != address(0));
69         if (ethHandleRegistred[_handle] && ownsEthHandle[msg.sender][_handle]) {
70             ahs.registerHandle(ethBase, _handle, _addr);
71         }
72         if (!ethHandleRegistred[_handle]) {
73             ethHandleRegistred[_handle] = true;
74             ownsEthHandle[msg.sender][_handle] = true;
75             ahs.registerHandle(ethBase, _handle, _addr);
76         } else {
77             revert();
78         }
79     }
80 
81     function transferEthHandleOwnership(bytes32 _handle, address _addr) public {
82         require(ownsEthHandle[msg.sender][_handle]);
83         ownsEthHandle[msg.sender][_handle] = false;
84         ownsEthHandle[_addr][_handle] = true;
85     }
86 
87     function getEthBase() public view returns(bytes32) {
88         return ethBase;
89     }
90 
91     function ethHandleIsRegistered(bytes32 _handle) public view returns(bool) {
92         return ethHandleRegistred[_handle];
93     }
94 
95     function findAddress(bytes32 _handle) public view returns(address) {
96         address addr = ahs.findAddress(ethBase, _handle);
97         return addr;
98     }
99 
100     function doesOwnEthHandle(bytes32 _handle, address _addr) public view returns(bool) {
101         return ownsEthHandle[_addr][_handle];
102     }
103 
104     function transferBaseOwnership() public {
105         require(msg.sender == owner);
106         ahs.transferBase(ethBase, owner);
107     }
108 
109     function withdraw() public {
110         require(msg.sender == owner);
111         owner.transfer(this.balance);
112     }
113 
114 }