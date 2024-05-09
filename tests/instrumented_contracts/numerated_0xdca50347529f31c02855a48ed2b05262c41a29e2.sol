1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4   function mulSafe(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6        return 0;
7      }
8      uint256 c = a * b;
9      assert(c / a == b);
10      return c;
11    }
12 
13   function divSafe(uint256 a, uint256 b) internal pure returns (uint256) {
14      uint256 c = a / b;
15      return c;
16   }
17 
18   function subSafe(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20      return a - b;
21    }
22 
23   function addSafe(uint256 a, uint256 b) internal pure returns (uint256) {
24      uint256 c = a + b;
25     assert(c >= a);
26      return c;
27    }
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34     function Constructor() public { owner = msg.sender; }
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address _newOwner) public onlyOwner {
41         newOwner = _newOwner;
42     }
43     function acceptOwnership() public {
44         require(msg.sender == newOwner);
45         OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47         newOwner = address(0);
48     }
49 }
50 
51 contract ERC20 {
52    uint256 public totalSupply;
53    function balanceOf(address who) public view returns (uint256);
54    function transfer(address to, uint256 value) public returns (bool);
55    event Transfer(address indexed from, address indexed to, uint256 value);
56    function allowance(address owner, address spender) public view returns (uint256);
57    function transferFrom(address from, address to, uint256 value) public returns (bool);
58    function approve(address spender, uint256 value) public returns (bool);
59    event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract ERC223 {
63     function transfer(address to, uint value, bytes data) public;
64     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
65 }
66 
67 contract ERC223ReceivingContract { 
68     function tokenFallback(address _from, uint _value, bytes _data) public;
69 }
70 
71 contract StandardToken is ERC20, ERC223, SafeMath, Owned {
72   event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);
73   mapping(address => uint256) balances;
74   mapping (address => mapping (address => uint256)) internal allowed;
75 
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79     balances[msg.sender] = subSafe(balances[msg.sender], _value);
80     balances[_to] = addSafe(balances[_to], _value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return balances[_owner];
87    }
88 
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = subSafe(balances[_from], _value);
95      balances[_to] = addSafe(balances[_to], _value);
96      allowed[_from][msg.sender] = subSafe(allowed[_from][msg.sender], _value);
97     Transfer(_from, _to, _value);
98      return true;
99    }
100 
101    function approve(address _spender, uint256 _value) public returns (bool) {
102      allowed[msg.sender][_spender] = _value;
103      Approval(msg.sender, _spender, _value);
104      return true;
105    }
106 
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108      return allowed[_owner][_spender];
109    }
110 
111    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
112      allowed[msg.sender][_spender] = addSafe(allowed[msg.sender][_spender], _addedValue);
113      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114      return true;
115    }
116 
117   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118      uint oldValue = allowed[msg.sender][_spender];
119      if (_subtractedValue > oldValue) {
120        allowed[msg.sender][_spender] = 0;
121      } else {
122        allowed[msg.sender][_spender] = subSafe(oldValue, _subtractedValue);
123     }
124      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125      return true;
126    }
127 
128     function transfer(address _to, uint _value, bytes _data) public {
129         require(_value > 0 );
130         if(isContract(_to)) {
131             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
132             receiver.tokenFallback(msg.sender, _value, _data);
133         }
134         balances[msg.sender] = subSafe(balances[msg.sender], _value);
135         balances[_to] = addSafe(balances[_to], _value);
136         Transfer(msg.sender, _to, _value, _data);
137     }
138 
139     function isContract(address _addr) private view returns (bool is_contract) {
140       uint length;
141       assembly {
142             //retrieve the size of the code on target address, this needs assembly
143             length := extcodesize(_addr)
144       }
145       return (length>0);
146     }
147 
148 }
149 
150 contract TOSToken is StandardToken {
151   string public name = 'TOSToken';
152   string public symbol = 'TOS';
153   uint public decimals = 18;
154 
155   uint256 public createTime         = 1527436800;  //20180528 //1528128000;  //20180605 00:00:00
156   uint256 public bonusEnds          = 1528646400;  //20180611 00:00:00
157   uint256 public endDate            = 1529078400;  //20180616 00:00:00
158   uint256 firstAnnual               = 1559318400;
159   uint256 secondAnnual              = 1590940800;
160   uint256 thirdAnnual               = 1622476800;
161 
162   uint256 public INITIAL_SUPPLY     = 1000000000;
163   uint256 public frozenForever      =  400000000;
164 
165   uint256 firstAnnualReleasedAmount =  150000000;
166   uint256 secondAnnualReleasedAmount=  150000000;
167   uint256 thirdAnnualReleasedAmount =  100000000;
168 
169   function TOSToken() public {
170     totalSupply = 200000000 ; 
171     balances[msg.sender] = totalSupply * 10 ** uint256(decimals);
172     owner = msg.sender;
173   }
174 
175   function releaseSupply() public onlyOwner returns(uint256 _actualRelease) {
176     uint256 releaseAmount = getReleaseAmount();
177     require(releaseAmount > 0);
178     balances[owner] = addSafe(balances[owner], releaseAmount * 10 ** uint256(decimals));
179     totalSupply = addSafe(totalSupply, releaseAmount);
180     Transfer(address(0), msg.sender, releaseAmount);
181     return releaseAmount;
182   }
183 
184   function getReleaseAmount() internal returns(uint256 _actualRelease) {
185         uint256 _amountToRelease;
186         if (    now >= firstAnnual
187              && now < secondAnnual
188              && firstAnnualReleasedAmount > 0) {
189             _amountToRelease = firstAnnualReleasedAmount;
190             firstAnnualReleasedAmount = 0;
191         } else if (    now >= secondAnnual 
192                     && now < thirdAnnual
193                     && secondAnnualReleasedAmount > 0) {
194             _amountToRelease = secondAnnualReleasedAmount;
195             secondAnnualReleasedAmount = 0;
196         } else if (    now >= thirdAnnual 
197                     && thirdAnnualReleasedAmount > 0) {
198             _amountToRelease = thirdAnnualReleasedAmount;
199             thirdAnnualReleasedAmount = 0;
200         } else {
201             _amountToRelease = 0;
202         }
203         return _amountToRelease;
204     }
205 
206     function () public payable {
207         require(now >= createTime && now <= endDate);
208         uint tokens;
209         if (now <= bonusEnds) {
210             tokens = msg.value * 2480;
211         } else {
212             tokens = msg.value * 2000;
213         }
214         require(tokens <= balances[owner]);
215         balances[msg.sender] = addSafe(balances[msg.sender], tokens);
216         //_totalSupply = addSafe(_totalSupply, tokens);
217         Transfer(address(0), msg.sender, tokens);
218         owner.transfer(msg.value);
219     }
220 }