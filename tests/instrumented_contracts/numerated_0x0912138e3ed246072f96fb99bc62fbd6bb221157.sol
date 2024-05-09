1 pragma solidity ^0.4.24;
2 
3 contract ERC20TokenSAC {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     address public cfoOfTokenSAC;
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
25             cfoOfTokenSAC = msg.sender;
26             totalSupply = initialSupply * 10 ** uint256(decimals);
27             balanceOf[msg.sender] = totalSupply;
28             name = tokenName;
29             symbol = tokenSymbol;
30         }
31     
32     modifier onlycfo {
33         require (msg.sender == cfoOfTokenSAC);
34         _;
35     }
36     
37     function _transfer (address _from, address _to, uint _value) internal {
38         require (!frozenAccount[_from]);
39         require (!frozenAccount[_to]);
40         require (_to != address(0x0));
41         require (balanceOf[_from] >= _value);
42         require (balanceOf[_to] + _value >= balanceOf[_to]);
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
57         _transfer (_from, _to, _value);
58         allowance[_from][msg.sender] -= _value;
59         return true;
60     }
61     
62     function approve (address _spender, uint256 _value) public returns (bool success) {
63         require (_spender != address(0x0));
64         require (_value != 0);
65         allowance[msg.sender][_spender] = _value;
66         emit Approval (msg.sender, _spender, _value);
67         return true;
68     }
69     
70     function appointNewcfo (address newcfo) onlycfo public returns (bool) {
71         require (newcfo != address(0x0));
72         require (newcfo != cfoOfTokenSAC);
73         cfoOfTokenSAC = newcfo;
74         return true;
75     }
76     
77     function mintToken (address target, uint256 amount) onlycfo public returns (bool) {
78         require (target != address(0x0));
79         require (amount != 0);
80         balanceOf[target] += amount;
81         totalSupply += amount;
82         emit MintToken (target, amount);
83         return true;
84     }
85     
86     function meltToken (address target, uint256 amount) onlycfo public returns (bool) {
87         require (target != address(0x0));
88         require (amount <= balanceOf[target]);
89         require (amount != 0);
90         balanceOf[target] -= amount;
91         totalSupply -= amount;
92         emit MeltToken (target, amount);
93         return true;
94     }
95     
96     function freezeAccount (address target, bool freeze) onlycfo public returns (bool) {
97         require (target != address(0x0));
98         frozenAccount[target] = freeze;
99         emit FreezeEvent (target, freeze);
100         return true;
101     }
102 }