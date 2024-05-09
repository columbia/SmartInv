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
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         _transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
32         require(_value <= allowance[_from][msg.sender]);
33         allowance[_from][msg.sender] -= _value;
34         _transfer(_from, _to, _value);
35         return true;
36     }
37 
38     function approve(address _spender, uint256 _value) public returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         Approval(msg.sender, _spender, _value);
41         return true;
42     }
43 }
44 
45 contract ICOToken is BaseToken {
46     // 1 ether = icoRatio token
47     uint256 public icoRatio;
48     uint256 public icoBegintime;
49     uint256 public icoEndtime;
50     address public icoSender;
51     address public icoHolder;
52 
53     event ICO(address indexed from, uint256 indexed value, uint256 tokenValue);
54     event Withdraw(address indexed from, address indexed holder, uint256 value);
55 
56     function ico() public payable {
57         require(now >= icoBegintime && now <= icoEndtime);
58         uint256 tokenValue = (msg.value * icoRatio * 10 ** uint256(decimals)) / (1 ether / 1 wei);
59         if (tokenValue == 0 || balanceOf[icoSender] < tokenValue) {
60             revert();
61         }
62         _transfer(icoSender, msg.sender, tokenValue);
63         ICO(msg.sender, msg.value, tokenValue);
64     }
65 
66     function withdraw() public {
67         uint256 balance = this.balance;
68         icoHolder.transfer(balance);
69         Withdraw(msg.sender, icoHolder, balance);
70     }
71 }
72 
73 contract CustomToken is BaseToken, ICOToken {
74     function CustomToken() public {
75         totalSupply = 268000000000000000000000000;
76         name = 'YuanDevelopersCoin';
77         symbol = 'YDS';
78         decimals = 18;
79         balanceOf[0x0b8d528b35d0e5d6826ecad665c51dab5a671c13] = totalSupply;
80         Transfer(address(0), 0x0b8d528b35d0e5d6826ecad665c51dab5a671c13, totalSupply);
81 
82         icoRatio = 6000;
83         icoBegintime = 1530504000;
84         icoEndtime = 1533182400;
85         icoSender = 0x916c83760051ab9a2ab0b583193756867ba2cb3a;
86         icoHolder = 0x916c83760051ab9a2ab0b583193756867ba2cb3a;
87     }
88 
89     function() public payable {
90         ico();
91     }
92 }