1 pragma solidity ^0.4.15;
2 
3 //
4 // BUZZ is a voucher used as payment within Buzz.im website. 
5 // You can use this token to pay for advertising on the network.
6 // Ofcourse you can also use Fiat currencies and pay with credit
7 // card, but the amount of Buzz credited to your account will be
8 // converted according to current exchange rate on decetralized
9 // exchanges.
10 //
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract Base {
35     modifier only(address allowed) {
36         require(msg.sender == allowed);
37         _;
38     }
39 }
40 
41 contract Owned is Base {
42     address public owner;
43     address newOwner;
44     function Owned() public {
45         owner = msg.sender;
46     }
47     function transferOwnership(address _newOwner) only(owner) public {
48         newOwner = _newOwner;
49     }
50     function acceptOwnership() only(newOwner) public {
51         OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53     }
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 }
56 
57 contract ERC20 is Owned {
58     using SafeMath for uint;
59     event Transfer(address indexed _from, address indexed _to, uint _value);
60     event Approval(address indexed _owner, address indexed _spender, uint _value);
61     function transfer(address _to, uint _value) isStartedOnly public returns (bool success) {
62         require(_to != address(0));
63         require(_value <= balances[msg.sender]);
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70     function transferFrom(address _from, address _to, uint _value) isStartedOnly public returns (bool success) {
71         require(_to != address(0));
72         require(_value <= balances[_from]);
73         require(_value <= allowed[_from][msg.sender]);
74         balances[_from] = balances[_from].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77         Transfer(_from, _to, _value);
78         return true;
79     }
80     function balanceOf(address _owner) constant public returns (uint balance) {
81         return balances[_owner];
82     }
83     function approve_fixed(address _spender, uint _currentValue, uint _value) isStartedOnly public returns (bool success) {
84         if(allowed[msg.sender][_spender] == _currentValue){
85             allowed[msg.sender][_spender] = _value;
86             Approval(msg.sender, _spender, _value);
87             return true;
88         } else {
89             return false;
90         }
91     }
92     function approve(address _spender, uint _value) isStartedOnly public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97     function allowance(address _owner, address _spender) constant public returns (uint remaining) {
98         return allowed[_owner][_spender];
99     }
100     mapping (address => uint) balances;
101     mapping (address => mapping (address => uint)) allowed;
102     uint public totalSupply;
103     bool    public isStarted = false;
104     modifier isStartedOnly() {
105         require(isStarted);
106         _;
107     }
108 
109 }
110 
111 contract BUZZ is ERC20 {
112     using SafeMath for uint;
113     string public name = "Buzz.im";
114     string public symbol = "BUZZ";
115     uint8 public decimals = 18;
116     modifier isNotStartedOnly() {
117         require(!isStarted);
118         _;
119     }
120     function getTotalSupply()
121     public
122     constant
123     returns(uint)
124     {
125         return totalSupply;
126     }
127     
128     // Bootstrap the contract and make the tokens
129     // transferrable. No more minting will be possible.
130     function start()
131     public
132     only(owner)
133     isNotStartedOnly
134     {
135         isStarted = true;
136     }
137 
138     function multiTransfer(address[] dests, uint[] values) public
139     only(owner)
140     isStartedOnly
141     returns (uint) {
142         uint i = 0;
143         while (i < dests.length) {
144            transfer(dests[i], values[i]);
145            i += 1;
146         }
147         return(i);
148     }
149 
150     //
151     // before start:
152     // 
153     function mint(address _to, uint _amount) public
154     only(owner)
155     isNotStartedOnly
156     returns(bool)
157     {
158         totalSupply = totalSupply.add(_amount);
159         balances[_to] = balances[_to].add(_amount);
160         Transfer(msg.sender, _to, _amount);
161         return true;
162     }
163 }