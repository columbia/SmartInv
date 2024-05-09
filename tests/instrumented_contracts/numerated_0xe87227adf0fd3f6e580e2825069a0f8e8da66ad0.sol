1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: contracts/interfaces/IAccessToken.sol
56 
57 interface IAccessToken {
58   function lockBBK(
59     uint256 _value
60   )
61     external
62     returns (bool);
63 
64   function unlockBBK(
65     uint256 _value
66   )
67     external
68     returns (bool);
69 
70   function transfer(
71     address _to,
72     uint256 _value
73   )
74     external
75     returns (bool);
76 
77   function distribute(
78     uint256 _amount
79   )
80     external
81     returns (bool);
82 
83   function burn(
84     address _address,
85     uint256 _value
86   )
87     external
88     returns (bool);
89 }
90 
91 // File: contracts/interfaces/IRegistry.sol
92 
93 // limited ContractRegistry definition
94 interface IRegistry {
95   function owner()
96     external
97     returns(address);
98 
99   function updateContractAddress(
100     string _name,
101     address _address
102   )
103     external
104     returns (address);
105 
106   function getContractAddress(
107     string _name
108   )
109     external
110     view
111     returns (address);
112 }
113 
114 // File: contracts/FeeManager.sol
115 
116 contract FeeManager {
117   using SafeMath for uint256;
118 
119   uint8 public constant version = 1;
120   uint256 actRate = 1000;
121 
122   IRegistry private registry;
123   constructor(
124     address _registryAddress
125   )
126     public
127   {
128     require(_registryAddress != address(0));
129     registry = IRegistry(_registryAddress);
130   }
131 
132   function weiToAct(uint256 _wei)
133     public
134     view
135     returns (uint256)
136   {
137 
138     return _wei.mul(actRate);
139   }
140 
141   function actToWei(uint256 _act)
142     public
143     view
144     returns (uint256)
145   {
146     return _act.div(actRate);
147   }
148 
149   function payFee()
150     public
151     payable
152     returns (bool)
153   {
154     IAccessToken act = IAccessToken(
155       registry.getContractAddress("AccessToken")
156     );
157     require(act.distribute(weiToAct(msg.value)));
158     return true;
159   }
160 
161   function claimFee(
162     uint256 _value
163   )
164     public
165     returns (bool)
166   {
167     IAccessToken act = IAccessToken(
168       registry.getContractAddress("AccessToken")
169     );
170     require(act.burn(msg.sender, _value));
171     msg.sender.transfer(actToWei(_value));
172     return true;
173   }
174 }