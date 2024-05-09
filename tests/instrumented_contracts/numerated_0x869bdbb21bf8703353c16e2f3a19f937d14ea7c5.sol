1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));      
37     owner = newOwner;
38   }
39 
40 }
41 
42 contract SharkProxy is Ownable {
43 
44   event Deposit(address indexed sender, uint256 value);
45   event Withdrawal(address indexed to, uint256 value, bytes data);
46 
47   function SharkProxy() {
48     owner = msg.sender;
49   }
50 
51   function getOwner() constant returns (address) {
52     return owner;
53   }
54 
55   function forward(address _destination, uint256 _value, bytes _data) onlyOwner {
56     require(_destination != address(0));
57     assert(_destination.call.value(_value)(_data)); // send eth and/or data
58     if (_value > 0) {
59       Withdrawal(_destination, _value, _data);
60     }
61   }
62 
63   /**
64    * Default function; is called when Ether is deposited.
65    */
66   function() payable {
67     Deposit(msg.sender, msg.value);
68   }
69 
70   /**
71    * @dev is called when ERC223 token is deposited.
72    */
73   function tokenFallback(address _from, uint _value, bytes _data) {
74   }
75 
76 }
77 
78 
79 contract FishProxy is SharkProxy {
80 
81   // this address can sign receipt to unlock account
82   address lockAddr;
83 
84   function FishProxy(address _owner, address _lockAddr) {
85     owner = _owner;
86     lockAddr = _lockAddr;
87   }
88 
89   function isLocked() constant returns (bool) {
90     return lockAddr != 0x0;
91   }
92 
93   function unlock(bytes32 _r, bytes32 _s, bytes32 _pl) {
94     assert(lockAddr != 0x0);
95     // parse receipt data
96     uint8 v;
97     uint88 target;
98     address newOwner;
99     assembly {
100         v := calldataload(37)
101         target := calldataload(48)
102         newOwner := calldataload(68)
103     }
104     // check permission
105     assert(target == uint88(address(this)));
106     assert(newOwner == msg.sender);
107     assert(newOwner != owner);
108     assert(ecrecover(sha3(uint8(0), target, newOwner), v, _r, _s) == lockAddr);
109     // update state
110     owner = newOwner;
111     lockAddr = 0x0;
112   }
113 
114   /**
115    * Default function; is called when Ether is deposited.
116    */
117   function() payable {
118     // if locked, only allow 0.1 ETH max
119     // Note this doesn't prevent other contracts to send funds by using selfdestruct(address);
120     // See: https://github.com/ConsenSys/smart-contract-best-practices#remember-that-ether-can-be-forcibly-sent-to-an-account
121     assert(lockAddr == address(0) || this.balance <= 1e17);
122     Deposit(msg.sender, msg.value);
123   }
124 
125 }
126 
127 
128 contract FishFactory {
129 
130   event AccountCreated(address proxy);
131 
132   function create(address _owner, address _lockAddr) {
133     address proxy = new FishProxy(_owner, _lockAddr);
134     AccountCreated(proxy);
135   }
136 
137 }