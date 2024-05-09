1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     
5   function mul(uint256 a, uint256 b) internal  pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28   
29 }
30 
31 contract Ownable {
32     
33     address public owner;
34     
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     
45 }
46 
47 contract Blin is Ownable {
48      using SafeMath for uint256;
49     string public  name = "Afonja";
50     
51     string public  symbol = "GROSH";
52     
53     uint32 public  decimals = 0;
54     
55     uint public totalSupply = 0;
56     
57     mapping (address => uint) balances;
58     
59   
60 	uint rate = 100000;
61 	
62 	function Blin()public {
63 
64 	
65 	
66 	}
67     
68     function mint(address _to, uint _value) internal{
69         assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
70         balances[_to] += _value;
71         totalSupply += _value;
72     }
73     
74     function balanceOf(address _owner) public constant returns (uint balance) {
75         return balances[_owner];
76     }
77 
78     function transfer(address _to, uint _value) public returns (bool success) {
79         if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
80             balances[msg.sender] -= _value; 
81             balances[_to] += _value;
82             Transfer(msg.sender, _to, _value);
83             return true;
84         } 
85         return false;
86     }
87     
88 
89  
90     
91     event Transfer(address indexed _from, address indexed _to, uint _value);
92     
93 
94     
95 	
96     function createTokens()  public payable {
97      //  transfer(msg.sender,msg.value);
98 	   owner.transfer(msg.value);
99        uint tokens = rate.mul(msg.value).div(1 ether);
100         mint(msg.sender, tokens);
101     }
102 
103     function() external payable {
104         createTokens();
105     }
106 	
107 }