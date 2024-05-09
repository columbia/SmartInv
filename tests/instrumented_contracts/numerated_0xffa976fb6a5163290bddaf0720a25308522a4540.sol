1 pragma solidity ^0.4.22;
2 
3 contract TokenTTDfourth {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     address public cfoOfTokenTTDfourth;
9     
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     mapping (address => bool) public frozenAccount;
13     
14     event Transfer (address indexed from, address indexed to, uint256 value);
15     event Approval (address indexed owner, address indexed spender, uint256 value);
16     event MintToken (address to, uint256 mintvalue);
17     event MeltToken (address from, uint256 meltvalue);
18     event FreezeEvent (address target, bool result);
19     
20     constructor (
21         uint256 initialSupply,
22         string memory tokenName,
23         string memory tokenSymbol
24         ) public {
25             cfoOfTokenTTDfourth = msg.sender;
26             totalSupply = initialSupply * 10 ** uint256(decimals);
27             balanceOf[msg.sender] = totalSupply;
28             name = tokenName;
29             symbol = tokenSymbol;
30         }
31     
32     modifier onlycfo {
33         require (msg.sender == cfoOfTokenTTDfourth);
34         _;
35     }
36     
37     function _transfer (address _from, address _to, uint _value) internal {
38         require (_to != address(0x0));
39         require (balanceOf[_from] >= _value);
40         require (balanceOf[_to] + _value >= balanceOf[_to]);
41         require (!frozenAccount[_from]);
42         require (!frozenAccount[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         emit Transfer (_from, _to, _value);
47         assert (balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49     
50     function transfer (address _to, uint256 _value) public returns (bool success) {
51         _transfer (msg.sender, _to, _value);
52         return true;
53     }
54     
55     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
56         require (_value <= allowance[_from][msg.sender]);
57         allowance[_from][msg.sender] -= _value;
58         _transfer (_from, _to, _value);
59         return true;
60     }
61     
62     function approve (address _spender, uint256 _value) public returns (bool success) {
63         require (_spender != address(0x0));
64         require (_value > 0);
65         allowance[msg.sender][_spender] = _value;
66         emit Approval (msg.sender, _spender, _value);
67         return true;
68     }
69     
70     function appointNewcfo (address newcfo) onlycfo public {
71         require (newcfo != address(0x0));
72         require (newcfo != cfoOfTokenTTDfourth);
73         cfoOfTokenTTDfourth = newcfo;
74     }
75     
76     function mintToken (address target, uint256 amount) onlycfo public {
77         require (target != address(0x0));
78         require (amount > 0);
79         balanceOf[target] += amount;
80         totalSupply += amount;
81         emit MintToken (target, amount);
82     }
83     
84     function meltToken (address target, uint256 amount) onlycfo public {
85         require (target != address(0x0));
86         require (amount <= balanceOf[target]);
87         balanceOf[target] -= amount;
88         totalSupply -= amount;
89         emit MeltToken (target, amount);
90     }
91     
92     function freezeAccount (address target, bool freeze) onlycfo public {
93         require (target != address(0x0));
94         frozenAccount[target] = freeze;
95         emit FreezeEvent (target, freeze);
96     }
97 }