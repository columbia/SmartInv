1 pragma solidity ^0.4.24;
2 
3     /*
4     Wo Men Yi Qi Lai Nian Fo:
5     अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ अमिताभ.
6     འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད། འོད་དཔག་མེད།.
7     아미타불 아미타불 아미타불 아미타불 아미타불 아미타불 아미타불 아미타불 아미타불 아미타불.
8     阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛 阿弥陀佛.
9     阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛 阿彌陀佛.
10     Amitabha Amitabha Amitabha Amitabha Amitabha Amitabha Amitabha Amitabha Amitabha Amitabha.
11     พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ พระอมิตาภพุทธะ.
12     Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật Adiđàphật.
13     ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ ᠴᠠᠭᠯᠠᠰᠢ ᠦᠭᠡᠢ ᠭᠡᠷᠡᠯᠲᠦ.
14     Jiang Wo Suo Xiu De Yi Qie Gong De,Hui Xiang Gei Fa Jie Yi Qie Zhong Sheng.
15     */
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     require(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a / b;
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     require(c >= a);
40     return c;
41   }
42 }
43 
44 
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 
68 contract TEST008 is Ownable{
69     
70     using SafeMath for uint256;
71     
72     string public constant name       = "TEST008";
73     string public constant symbol     = "测试八";
74     uint32 public constant decimals   = 18;
75     uint256 public totalSupply        = 999999 ether;
76     uint256 public currentTotalSupply = 0;
77     uint256 startBalance              = 999 ether;
78     
79     mapping(address => bool) touched;
80     mapping(address => uint256) balances;
81     mapping (address => mapping (address => uint256)) internal allowed;
82     
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     
86 
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89 
90         if( !touched[msg.sender] && currentTotalSupply < totalSupply ){
91             balances[msg.sender] = balances[msg.sender].add( startBalance );
92             touched[msg.sender] = true;
93             currentTotalSupply = currentTotalSupply.add( startBalance );
94         }
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
108         
109         require(_value <= allowed[_from][msg.sender]);
110         
111         if( !touched[_from] && currentTotalSupply < totalSupply ){
112             touched[_from] = true;
113             balances[_from] = balances[_from].add( startBalance );
114             currentTotalSupply = currentTotalSupply.add( startBalance );
115         }
116         
117         require(_value <= balances[_from]);
118         
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         emit Transfer(_from, _to, _value);
123         return true;
124     }
125 
126 
127     function approve(address _spender, uint256 _value) public returns (bool) {
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133 
134     function allowance(address _owner, address _spender) public view returns (uint256) {
135         return allowed[_owner][_spender];
136      }
137 
138 
139     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
140         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
141         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142         return true;
143     }
144 
145 
146     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147         uint oldValue = allowed[msg.sender][_spender];
148         if (_subtractedValue > oldValue) {
149           allowed[msg.sender][_spender] = 0;
150         } else {
151           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152         }
153         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155      }
156     
157 
158     function getBalance(address _a) internal constant returns(uint256)
159     {
160         if( currentTotalSupply < totalSupply ){
161             if( touched[_a] )
162                 return balances[_a];
163             else
164                 return balances[_a].add( startBalance );
165         } else {
166             return balances[_a];
167         }
168     }
169     
170 
171     function balanceOf(address _owner) public view returns (uint256 balance) {
172         return getBalance( _owner );
173     }
174 }