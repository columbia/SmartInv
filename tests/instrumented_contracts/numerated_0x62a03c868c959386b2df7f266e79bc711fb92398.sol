1 pragma solidity ^0.4.18;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a * b;
5         assert(a == 0 || c / a == b);
6         return c;
7     }
8 
9     function div(uint256 a, uint256 b) internal pure returns (uint256) {
10         // assert(b > 0); // Solidity automatically throws when dividing by 0
11         uint256 c = a / b;
12         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
28         return a >= b ? a : b;
29     }
30 
31     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
32         return a < b ? a : b;
33     }
34 
35     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
36         return a >= b ? a : b;
37     }
38 
39     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a < b ? a : b;
41     }
42 }
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51     address public owner;
52     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param _newOwner The address to transfer ownership to.
73      */
74     function changeOwner(address _newOwner) onlyOwner public {
75         require(_newOwner != address(0));
76         OwnerChanged(owner, _newOwner);
77         owner = _newOwner;
78     }
79 
80 }
81 
82 interface Token {
83     function transfer(address _to, uint256 _value) public;
84     function balanceOf(address _owner) public constant returns (uint256 balance);
85     //function transfer(address _to, uint256 _value) public returns (bool success);
86     //event Transfer(address indexed _from, address indexed _to, uint256 _value);
87 }
88 
89 
90 contract BatchTransfer is Ownable {
91     using SafeMath for uint256;
92     event TransferToken(address indexed from, address indexed to, uint256 value);
93     Token public standardToken;
94     // List of admins
95     mapping (address => bool) public contractAdmins;
96     mapping (address => bool) public userTransfered;
97     uint256 public totalUserTransfered;
98 
99     function BatchTransfer(address _owner) public {
100         require(_owner != address(0));
101         owner = _owner;
102         owner = msg.sender; //for test
103     }
104 
105     function setContractToken (address _addressContract) public onlyOwner {
106         require(_addressContract != address(0));
107         standardToken = Token(_addressContract);
108         totalUserTransfered = 0;
109     }
110 
111     function balanceOf(address _owner) public constant returns (uint256 balance) {
112         return standardToken.balanceOf(_owner);
113     }
114 
115     modifier onlyOwnerOrAdmin() {
116         require(msg.sender == owner || contractAdmins[msg.sender]);
117         _;
118     }
119 
120     /**
121     * @dev Add an contract admin
122     */
123     function setContractAdmin(address _admin, bool _isAdmin) public onlyOwner {
124         contractAdmins[_admin] = _isAdmin;
125     }
126 
127     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
128     function batchTransfer(address[] _recipients, uint256[] _values) external onlyOwnerOrAdmin returns (bool) {
129         require( _recipients.length > 0 && _recipients.length == _values.length);
130         uint256 total = 0;
131         for(uint i = 0; i < _values.length; i++){
132             total = total.add(_values[i]);
133         }
134         require(total <= standardToken.balanceOf(msg.sender));
135         for(uint j = 0; j < _recipients.length; j++){
136             standardToken.transfer(_recipients[j], _values[j]);
137             totalUserTransfered = totalUserTransfered.add(1);
138             userTransfered[_recipients[j]] = true;
139             TransferToken(msg.sender, _recipients[j], _values[j]);
140         }
141         return true;
142     }
143 }