1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 
55 contract IOTS is Ownable{
56     
57     using SafeMath for uint256;
58     
59     string public constant name       = "IOTS Token";
60     string public constant symbol     = "IOTS";
61     uint32 public constant decimals   = 18;
62     uint256 public constant totalSupply        = 12000000000  * (10 ** uint256(decimals));
63  
64     uint256 public constant lockSupply        =   4000000000  * (10 ** uint256(decimals));
65    
66     uint256 public constant teamSupply        =   8000000000  * (10 ** uint256(decimals));
67 
68  
69     
70     uint public lockAtTime;
71     
72  
73     mapping(address => uint256) balances;
74     mapping (address => mapping (address => uint256)) internal allowed;
75     
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78     
79     address constant teamAddr = 0xf65EDCb3B229bCE3c1909C60dDd0885F610D97BC;
80 
81     constructor() public {
82       
83       lockAtTime = now;
84       balances[teamAddr] = teamSupply;
85       emit Transfer(0x0, teamAddr, teamSupply);
86 
87       balances[address(this)] = lockSupply;
88       emit Transfer(0x0, address(this), lockSupply);
89  
90     }
91 
92     function transfer(address _to, uint256 _value) public returns (bool) {
93         require(_to != address(0));
94         //require(checkLocked(msg.sender, _value));
95  
96         require(_value <= balances[msg.sender]);
97         
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100     
101         emit Transfer(msg.sender, _to, _value);
102         return true;
103     }
104   
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         //require(checkLocked(_from, _value));
109         
110         require(_value <= allowed[_from][msg.sender]);
111  
112         require(_value <= balances[_from]);
113         
114         balances[_from] = balances[_from].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117         emit Transfer(_from, _to, _value);
118         return true;
119     }
120 
121 
122     function approve(address _spender, uint256 _value) public returns (bool) {
123         allowed[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128 
129     function allowance(address _owner, address _spender) public view returns (uint256) {
130         return allowed[_owner][_spender];
131      }
132 
133 
134     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
135         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140 
141     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142         uint oldValue = allowed[msg.sender][_spender];
143         if (_subtractedValue > oldValue) {
144           allowed[msg.sender][_spender] = 0;
145         } else {
146           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147         }
148         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149         return true;
150      }
151     
152  
153 
154     function balanceOf(address _owner) public view returns (uint256 balance) {
155         return balances[_owner];
156     }
157  
158    function checkLocked(address _addr, uint256 _value) internal view returns (bool) {
159          if (now > lockAtTime  + 4 years) {  
160              return true;
161          } else if (now > lockAtTime + 3 years)   {
162              return (balances[_addr] - _value >= lockSupply / 5 );
163          } else if (now > lockAtTime + 2 years)   {
164              return (balances[_addr] - _value >= lockSupply / 5 * 2);    
165          } else if (now > lockAtTime + 1 years)   {
166              return (balances[_addr] - _value >= lockSupply / 5 * 3);      
167          }  else {
168              return (balances[_addr] - _value >= lockSupply / 5 * 4);     
169          }  
170  
171    } 
172 
173     function withdrawal( ) onlyOwner public {
174         uint256 _value = getFreeBalances();
175         require(_value > 0 );
176         require(checkLocked(address(this), _value));
177 
178         require(_value <= balances[address(this)]);
179         
180         balances[address(this)] = balances[address(this)].sub(_value);
181         balances[teamAddr] = balances[teamAddr].add(_value);
182     
183         emit Transfer(address(this), teamAddr, _value);
184     }
185        
186    function getFreeBalances( ) public view returns(uint)  {
187      if (now > lockAtTime  + 4 years) {  
188              return balances[address(this)];
189          } else if (now > lockAtTime + 3 years)   {
190              return (balances[address(this)] - lockSupply / 5 );
191          } else if (now > lockAtTime + 2 years)   {
192              return (balances[address(this)] - lockSupply / 5 * 2);    
193          } else if (now > lockAtTime + 1 years)   {
194              return (balances[address(this)] - lockSupply / 5 * 3);      
195          }  else {
196              return (balances[address(this)] - lockSupply / 5 * 4);     
197       }
198    }
199 
200  
201 
202 }