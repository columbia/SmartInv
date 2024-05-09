1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 contract ERC20Basic {
17   uint256 public totalSupply;
18   function balanceOf(address who) public constant returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 contract BasicToken is ERC20Basic {
24   using SafeMath for uint256;
25 
26   struct restrict {
27         uint amount;
28         uint restrictTime;
29   } 
30 
31   mapping(address => uint256) balances;
32   mapping (address => restrict) restricts;
33 
34   function getrestrict(address _owner) public view  returns (uint){
35       uint restrictAmount = 0;
36 
37       if(restricts[_owner].amount != 0){
38         if(restricts[_owner].restrictTime <= now){
39             uint diffmonth = (now - restricts[_owner].restrictTime) / (10 minutes);
40             if(diffmonth < 4){
41                 diffmonth = 4 - diffmonth;
42                 restrictAmount = (diffmonth * restricts[_owner].amount)/4;
43             }
44         }else{
45             restrictAmount = restricts[_owner].amount;
46         }
47       }
48 
49       return restrictAmount;
50   }
51 
52   function getrestrictTime(address _owner) public view returns (uint){
53       return restricts[_owner].restrictTime;
54   }
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) public returns (bool) {
62   
63     require(_to != address(0));
64     
65     uint restrictAmount =  getrestrict(msg.sender);
66     
67     require((_value + restrictAmount) <= balances[msg.sender]);
68     
69     /* if send address is AB, restrict token */ 
70     if(msg.sender == address(0xFA3aA02539d1217fe6Af1599913ddb1A852f1934)){
71         require(0 == restricts[_to].amount);
72         restricts[_to].restrictTime = now + (10 minutes);
73         restricts[_to].amount = _value;
74     } else if(msg.sender == address(0xD5345443886e2188e63609E77EA73d1df44Ea4BC)){
75         require(0 == restricts[_to].amount);
76         restricts[_to].restrictTime = now + (10 minutes);
77         restricts[_to].amount = _value;
78     } 
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84 
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 contract LockToken is BasicToken {
100 
101   string public constant name = "Lock Token";
102   string public constant symbol = "LKT";
103   uint8 public constant decimals = 18;
104 
105   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
106   
107   constructor() public {
108     totalSupply = INITIAL_SUPPLY;
109     balances[0xFA3aA02539d1217fe6Af1599913ddb1A852f1934] = 100000000 * (10 ** uint256(decimals));
110     balances[0xD5345443886e2188e63609E77EA73d1df44Ea4BC] = 800000000 * (10 ** uint256(decimals));
111     balances[0x617eC39184E1527e847449A5d8a252FfD7C29DDf] = 100000000 * (10 ** uint256(decimals));
112     
113     emit Transfer(msg.sender, 0xFA3aA02539d1217fe6Af1599913ddb1A852f1934, 100000000 * (10 ** uint256(decimals)));
114     emit Transfer(msg.sender, 0xD5345443886e2188e63609E77EA73d1df44Ea4BC, 800000000 * (10 ** uint256(decimals)));
115     emit Transfer(msg.sender, 0x617eC39184E1527e847449A5d8a252FfD7C29DDf, 100000000 * (10 ** uint256(decimals)));
116   }
117 }