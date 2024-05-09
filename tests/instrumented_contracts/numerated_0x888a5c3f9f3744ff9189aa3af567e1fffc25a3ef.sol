1 pragma solidity ^0.4.23;
2 contract BaseToken {
3     string public name;
4     string public symbol;
5     uint8 public decimals;
6     uint256 public totalSupply;
7     mapping (address => uint256) public balanceOf;
8     mapping (address => mapping (address => uint256)) public allowance;
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11     function _transfer(address _from, address _to, uint _value) internal {
12         require(_to != 0x0);
13         require(balanceOf[_from] >= _value);
14         require(balanceOf[_to] + _value > balanceOf[_to]);
15         uint previousBalances = balanceOf[_from] + balanceOf[_to];
16         balanceOf[_from] -= _value;
17         balanceOf[_to] += _value;
18         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
19         Transfer(_from, _to, _value);
20     }
21     function transfer(address _to, uint256 _value) public {
22         _transfer(msg.sender, _to, _value);
23     }
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
25         require(_value <= allowance[_from][msg.sender]);
26         allowance[_from][msg.sender] -= _value;
27         _transfer(_from, _to, _value);
28         return true;
29     }
30     function approve(address _spender, uint256 _value) public
31         returns (bool success) {
32         allowance[msg.sender][_spender] = _value;
33         Approval(msg.sender, _spender, _value);
34         return true;
35     }
36 }
37 contract BurnToken is BaseToken {
38     event Burn(address indexed from, uint256 value);
39     function burn(uint256 _value) public returns (bool success) {
40         require(balanceOf[msg.sender] >= _value);
41         balanceOf[msg.sender] -= _value;
42         totalSupply -= _value;
43         Burn(msg.sender, _value);
44         return true;
45     }
46     function burnFrom(address _from, uint256 _value) public returns (bool success) {
47         require(balanceOf[_from] >= _value);
48         require(_value <= allowance[_from][msg.sender]);
49         balanceOf[_from] -= _value;
50         allowance[_from][msg.sender] -= _value;
51         totalSupply -= _value;
52         Burn(_from, _value);
53         return true;
54     }
55 }
56 contract ICOToken is BaseToken {
57     // 1 ether = icoRatio token
58     uint256 public icoRatio;
59     uint256 public icoEndtime;
60     address public icoSender;
61     address public icoHolder;
62     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
63     event Withdraw(address indexed from, address indexed holder, uint256 value);
64     modifier onlyBefore() {
65         if (now > icoEndtime) {
66             revert();
67         }
68         _;
69     }
70     function() public payable onlyBefore {
71         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
72         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
73             revert();
74         }
75         _transfer(icoSender, msg.sender, tokenValue);
76         ICO(msg.sender, msg.value, tokenValue);
77     }
78     function withdraw() {
79         uint256 balance = this.balance;
80         icoHolder.transfer(balance);
81         Withdraw(msg.sender, icoHolder, balance);
82     }
83 }
84 contract CustomToken is BaseToken, BurnToken, ICOToken {
85     function CustomToken() public {
86         totalSupply = 1000000000000000000000000000;
87         balanceOf[0x852515f4389f0c9fd9fa4ca4d24d138b4d63dc8c] = totalSupply;
88         name = 'USDH';
89         symbol = 'USDH';
90         decimals = 18;
91         icoRatio = 100;
92         icoEndtime = 1573639200;
93         icoSender = 0x852515f4389f0c9fd9fa4ca4d24d138b4d63dc8c;
94         icoHolder = 0x852515f4389f0c9fd9fa4ca4d24d138b4d63dc8c;
95     }
96 }