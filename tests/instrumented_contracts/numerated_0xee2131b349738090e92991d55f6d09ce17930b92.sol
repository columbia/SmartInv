1 pragma solidity ^0.4.23;
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
38     address a = address(0xA9802C071dD0D9fC470A06a487a2DB3D938a7b02);
39     owner = a;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 
56 contract YLCHINAToken is Ownable{
57     
58     using SafeMath for uint256;
59     
60     string public constant name       = "YLCHINA";
61     string public constant symbol     = "DYLC";
62     uint32 public constant decimals   = 18;
63     uint256 public totalSupply        = 5000000000 ether;
64     uint256 public currentTotalAirdrop = 0;
65     uint256 totalAirdrop              = 2880000 ether;
66     uint256 startBalance              = 288 ether;
67     
68     mapping(address => bool) touched;
69     mapping(address => uint256) balances;
70     mapping (address => mapping (address => uint256)) internal allowed;
71     
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74     
75     constructor() public {
76         balances[owner] = totalSupply - totalAirdrop;
77     }
78 
79     function transfer(address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81 
82         if( !touched[msg.sender] && currentTotalAirdrop < totalAirdrop ){
83             balances[msg.sender] = balances[msg.sender].add( startBalance );
84             touched[msg.sender] = true;
85             currentTotalAirdrop = currentTotalAirdrop.add( startBalance );
86         }
87         
88         require(_value <= balances[msg.sender]);
89         
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92     
93         emit Transfer(msg.sender, _to, _value);
94         return true;
95     }
96   
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         
101         require(_value <= allowed[_from][msg.sender]);
102         
103         if( !touched[_from] && currentTotalAirdrop < totalAirdrop ){
104             touched[_from] = true;
105             balances[_from] = balances[_from].add( startBalance );
106             currentTotalAirdrop = currentTotalAirdrop.add( startBalance );
107         }
108         
109         require(_value <= balances[_from]);
110         
111         balances[_from] = balances[_from].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114         emit Transfer(_from, _to, _value);
115         return true;
116     }
117 
118 
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125 
126     function allowance(address _owner, address _spender) public view returns (uint256) {
127         return allowed[_owner][_spender];
128      }
129 
130     function getBalance(address _a) internal constant returns(uint256)
131     {
132         if( currentTotalAirdrop < totalAirdrop ){
133             if( touched[_a] )
134                 return balances[_a];
135             else
136                 return balances[_a].add( startBalance );
137         } else {
138             return balances[_a];
139         }
140     }
141     
142 
143     function balanceOf(address _owner) public view returns (uint256 balance) {
144         return getBalance( _owner );
145     }
146 }