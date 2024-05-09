1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Ownerable.sol
4 
5 contract Ownerable {
6     /// @notice The address of the owner is the only address that can call
7     ///  a function with this modifier
8     modifier onlyOwner { require(msg.sender == owner); _; }
9 
10     address public owner;
11 
12     constructor() public { owner = msg.sender;}
13 
14     /// @notice Changes the owner of the contract
15     /// @param _newOwner The new owner of the contract
16     function setOwner(address _newOwner) public onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 // File: contracts/TokenController.sol
22 
23 contract TokenController {
24     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
25     /// @param _owner The address that sent the ether to create tokens
26     /// @return True if the ether is accepted, false if it throws
27     function proxyPayment(address _owner) public payable returns(bool);
28 
29     /// @notice Notifies the controller about a token transfer allowing the
30     ///  controller to react if desired
31     /// @param _from The origin of the transfer
32     /// @param _to The destination of the transfer
33     /// @param _amount The amount of the transfer
34     /// @return False if the controller does not authorize the transfer
35     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
36 
37     /// @notice Notifies the controller about an approval allowing the
38     ///  controller to react if desired
39     /// @param _owner The address that calls `approve()`
40     /// @param _spender The spender in the `approve()` call
41     /// @param _amount The amount in the `approve()` call
42     /// @return False if the controller does not authorize the approval
43     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
44 }
45 
46 // File: contracts/ATXICOToken.sol
47 
48 contract ATXICOToken {
49     function atxBuy(address _from, uint256 _amount) public returns(bool);
50 }
51 
52 // File: contracts/ATX.sol
53 
54 contract ATX {
55     function blacklistAccount(address tokenOwner) public returns (bool);
56     function unBlacklistAccount(address tokenOwner) public returns (bool);
57     function enableTransfers(bool _transfersEnabled) public;
58     function changeController(address _newController) public;
59 }
60 
61 // File: contracts/ATXController.sol
62 
63 contract ATXController is TokenController, Ownerable {
64 
65     address public atxContract;
66     mapping (address => bool) public icoTokens;
67 
68     event Debug(address indexed _from, address indexed _to, uint256 indexed _amount, uint ord);
69 
70     constructor (address _atxContract) public {
71         atxContract = _atxContract;
72     }
73 
74     function addICOToken(address _icoToken) public onlyOwner {
75         icoTokens[_icoToken] = true;
76     }
77     function delICOToken(address _icoToken) public onlyOwner {
78         icoTokens[_icoToken] = false;
79     }
80 
81     function proxyPayment(address _owner) public payable returns(bool) {
82         return false;
83     }
84 
85     function onTransfer(address _from, address _to, uint256 _amount) public returns(bool) {
86         require(atxContract == msg.sender);
87         require(_to != 0x0);
88 
89         // default
90         bool result = true;
91 
92         if(icoTokens[_to] == true) {
93             result = ATXICOToken(_to).atxBuy(_from, _amount);
94         }
95         return result;
96     }
97 
98     function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
99         return true;
100     }
101 
102     //
103     // for controlling ATX
104     function blacklist(address tokenOwner) public onlyOwner returns (bool) {
105         return ATX(atxContract).blacklistAccount(tokenOwner);
106     }
107 
108     function unBlacklist(address tokenOwner) public onlyOwner returns (bool) {
109         return ATX(atxContract).unBlacklistAccount(tokenOwner);
110     }
111 
112     function enableTransfers(bool _transfersEnabled) public onlyOwner {
113         ATX(atxContract).enableTransfers(_transfersEnabled);
114     }
115 
116     function changeController(address _newController) public onlyOwner {
117         ATX(atxContract).changeController(_newController);
118     }
119 
120     function changeATXTokenAddr(address _newTokenAddr) public onlyOwner {
121         atxContract = _newTokenAddr;
122     }
123 
124     function ownerMethod() public onlyOwner returns(bool) {
125       return true;
126     }
127 }