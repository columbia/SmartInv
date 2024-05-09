1 pragma solidity 0.4.16;
2 
3 
4 contract ControllerInterface {
5 
6 
7   // State Variables
8   bool public paused;
9   address public nutzAddr;
10 
11   // Nutz functions
12   function babzBalanceOf(address _owner) constant returns (uint256);
13   function activeSupply() constant returns (uint256);
14   function burnPool() constant returns (uint256);
15   function powerPool() constant returns (uint256);
16   function totalSupply() constant returns (uint256);
17   function allowance(address _owner, address _spender) constant returns (uint256);
18 
19   function approve(address _owner, address _spender, uint256 _amountBabz) public;
20   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public;
21   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public;
22 
23   // Market functions
24   function floor() constant returns (uint256);
25   function ceiling() constant returns (uint256);
26 
27   function purchase(address _sender, uint256 _value, uint256 _price) public returns (uint256);
28   function sell(address _from, uint256 _price, uint256 _amountBabz);
29 
30   // Power functions
31   function powerBalanceOf(address _owner) constant returns (uint256);
32   function outstandingPower() constant returns (uint256);
33   function authorizedPower() constant returns (uint256);
34   function powerTotalSupply() constant returns (uint256);
35 
36   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
37   function downTick(address _owner, uint256 _now) public;
38   function createDownRequest(address _owner, uint256 _amountPower) public;
39   function downs(address _owner) constant public returns(uint256, uint256, uint256);
40   function downtime() constant returns (uint256);
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48  
49 contract Ownable {
50   address public owner;
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) onlyOwner {
76     require(newOwner != address(0));      
77     owner = newOwner;
78   }
79 
80 }
81 
82 /*
83  * ERC20Basic
84  * Simpler version of ERC20 interface
85  * see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20Basic {
88   function totalSupply() constant returns (uint256);
89   function balanceOf(address _owner) constant returns (uint256);
90   function transfer(address _to, uint256 _value) returns (bool);
91   event Transfer(address indexed from, address indexed to, uint value);
92 }
93 
94 
95 contract Power is Ownable, ERC20Basic {
96 
97   event Slashing(address indexed holder, uint value, bytes32 data);
98 
99   string public name = "Acebusters Power";
100   string public symbol = "ABP";
101   uint256 public decimals = 12;
102 
103 
104   function balanceOf(address _holder) constant returns (uint256) {
105     return ControllerInterface(owner).powerBalanceOf(_holder);
106   }
107 
108   function totalSupply() constant returns (uint256) {
109     return ControllerInterface(owner).powerTotalSupply();
110   }
111 
112   function activeSupply() constant returns (uint256) {
113     return ControllerInterface(owner).outstandingPower();
114   }
115 
116 
117   // ############################################
118   // ########### ADMIN FUNCTIONS ################
119   // ############################################
120 
121   function slashPower(address _holder, uint256 _value, bytes32 _data) public onlyOwner {
122     Slashing(_holder, _value, _data);
123   }
124 
125   function powerUp(address _holder, uint256 _value) public onlyOwner {
126     // NTZ transfered from user's balance to power pool
127     Transfer(address(0), _holder, _value);
128   }
129 
130   // ############################################
131   // ########### PUBLIC FUNCTIONS ###############
132   // ############################################
133 
134   // registers a powerdown request
135   function transfer(address _to, uint256 _amountPower) public returns (bool success) {
136     // make Power not transferable
137     require(_to == address(0));
138     ControllerInterface(owner).createDownRequest(msg.sender, _amountPower);
139     Transfer(msg.sender, address(0), _amountPower);
140     return true;
141   }
142 
143   function downtime() public returns (uint256) {
144     ControllerInterface(owner).downtime;
145   }
146 
147   function downTick(address _owner) public {
148     ControllerInterface(owner).downTick(_owner, now);
149   }
150 
151   function downs(address _owner) constant public returns (uint256, uint256, uint256) {
152     return ControllerInterface(owner).downs(_owner);
153   }
154 
155 }