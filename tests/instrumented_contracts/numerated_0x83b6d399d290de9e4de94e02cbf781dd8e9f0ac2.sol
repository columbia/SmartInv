1 pragma solidity ^0.4.19;
2 
3 contract BaseToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function _transfer(address _from, address _to, uint _value) internal {
16         require(_to != 0x0);
17         require(balanceOf[_from] >= _value);
18         require(balanceOf[_to] + _value > balanceOf[_to]);
19         uint previousBalances = balanceOf[_from] + balanceOf[_to];
20         balanceOf[_from] -= _value;
21         balanceOf[_to] += _value;
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23         Transfer(_from, _to, _value);
24     }
25 
26     function transfer(address _to, uint256 _value) public {
27         _transfer(msg.sender, _to, _value);
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value <= allowance[_from][msg.sender]);
32         allowance[_from][msg.sender] -= _value;
33         _transfer(_from, _to, _value);
34         return true;
35     }
36 
37     function approve(address _spender, uint256 _value) public
38         returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 }
44 
45 contract ICOToken is BaseToken {
46     // 1 ether = icoRatio token
47     uint256 public icoRatio;
48     uint256 public icoEndtime;
49     address public icoSender;
50     address public icoHolder;
51 
52     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
53     event Withdraw(address indexed from, address indexed holder, uint256 value);
54 
55     modifier onlyBefore() {
56         if (now > icoEndtime) {
57             revert();
58         }
59         _;
60     }
61 
62     function() public payable onlyBefore {
63         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
64         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
65             revert();
66         }
67         _transfer(icoSender, msg.sender, tokenValue);
68         ICO(msg.sender, msg.value, tokenValue);
69     }
70 
71     function withdraw() {
72         uint256 balance = this.balance;
73         icoHolder.transfer(balance);
74         Withdraw(msg.sender, icoHolder, balance);
75     }
76 }
77 
78 contract CustomToken is BaseToken, ICOToken {
79     function CustomToken() public {
80         totalSupply = 2100000000000000;
81         balanceOf[0x1dd91123acc8a51392b35b310b2f0bed6ff082f2] = totalSupply;
82         name = 'ZYB';
83         symbol = 'free';
84         decimals = 8;
85         icoRatio = 10000;
86         icoEndtime = 1830268800;
87         icoSender = 0x1dd91123acc8a51392b35b310b2f0bed6ff082f2;
88         icoHolder = 0x723751481f1133d012e96209c88fc81ecdaca083;
89     }
90 }