1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title owned
33  * @dev The owned contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract owned {
37     address public owner;
38 
39     function owned() public {
40         owner = msg.sender;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) onlyOwner public {
56         owner = newOwner;
57     }
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken.
63  */
64 contract BasicToken {
65     using SafeMath for uint256;
66     
67     uint256       _supply;
68     mapping (address => uint256)    _balances;
69     
70     event Transfer( address indexed from, address indexed to, uint256 value);
71 
72     function BasicToken() public {    }
73     
74     function totalSupply() public view returns (uint256) {
75         return _supply;
76     }
77     function balanceOf(address _owner) public view returns (uint256) {
78         return _balances[_owner];
79     }
80     
81     /**
82      * @dev transfer token for a specified address
83      * @param _to The address to transfer to.
84      * @param _value The amount to be transferred.
85      */
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(_balances[msg.sender] >= _value);
88         
89         _balances[msg.sender] =_balances[msg.sender].sub(_value);
90         _balances[_to] =_balances[_to].add(_value);
91         
92         emit Transfer(msg.sender, _to, _value);
93         
94         return true;
95     }
96   
97 }
98 
99 contract DeBiToken is BasicToken,owned {
100     string  constant public symbol = "DB";
101     string  constant public name = "Digital Block";
102     uint256 constant public decimals =6; 
103     uint256 public lockedCounts = 8*(10**8)*(10**6);
104     uint256 public eachUnlockCounts = 2*(10**8)*(10**6);
105     //crowdSale end time, May/10/2018
106     uint256 public startTime = 1525881600;
107 
108     struct LockStruct {
109         uint256 unlockTime;
110         bool locked;
111     }
112 
113     LockStruct[] public unlockTimeMap;
114 
115     function DeBiToken() public {
116         _supply =50*(10**8)*(10**6);
117         _balances[0x01] = lockedCounts;
118          _balances[msg.sender] =_supply.sub(lockedCounts);
119 
120         // November/10/2018
121         unlockTimeMap.push(LockStruct({unlockTime:1541779200, locked: true})); 
122         // May/10/2019
123         unlockTimeMap.push(LockStruct({unlockTime:1557417600, locked: true})); 
124         // November/10/2019
125         unlockTimeMap.push(LockStruct({unlockTime:1573315200, locked: true})); 
126         // May/10/2020
127         unlockTimeMap.push(LockStruct({unlockTime:1589040000, locked: true})); 
128     }
129 
130     function transfer(address _to, uint256 _value) public returns (bool) {
131         require (now >= startTime);
132 
133         return super.transfer(_to, _value);
134     }
135 
136     function distribute(address _to, uint256 _value) onlyOwner public returns (bool) {
137 
138         return super.transfer(_to, _value);
139     }
140 
141     /**
142      * @dev unlock , only can be called by owner.
143      */
144     function unlock(uint256 _index) onlyOwner public {
145         require(_index>=0 && _index<unlockTimeMap.length);
146         require(now >= unlockTimeMap[_index].unlockTime && unlockTimeMap[_index].locked);
147         require(_balances[0x01] >= eachUnlockCounts);
148 
149         _balances[0x01] =_balances[0x01].sub(eachUnlockCounts);
150         _balances[owner] =_balances[owner].add(eachUnlockCounts);
151 
152         lockedCounts =lockedCounts.sub(eachUnlockCounts);
153         unlockTimeMap[_index].locked = false;
154 
155         emit Transfer(0x01, owner, eachUnlockCounts);
156     }
157 }