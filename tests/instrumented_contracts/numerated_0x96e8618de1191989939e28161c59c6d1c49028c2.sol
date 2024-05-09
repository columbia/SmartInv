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
45 contract AirdropToken is BaseToken {
46     uint256 public airAmount;
47     uint256 public airBegintime;
48     uint256 public airEndtime;
49     address public airSender;
50     uint32 public airLimitCount;
51 
52     mapping (address => uint32) public airCountOf;
53 
54     event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);
55 
56     function airdrop() public payable {
57         require(now >= airBegintime && now <= airEndtime);
58         require(msg.value == 0);
59         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
60             revert();
61         }
62         _transfer(airSender, msg.sender, airAmount);
63         airCountOf[msg.sender] += 1;
64         Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
65     }
66 }
67 
68 contract CustomToken is BaseToken, AirdropToken {
69     function CustomToken() public {
70         totalSupply = 1000000000000000000000000000;
71         name = 'PenZiBi';
72         symbol = 'PZB';
73         decimals = 18;
74         balanceOf[0xed1cbf659d5a8dd9e42c95c54c5f789db8fa4bfc] = totalSupply;
75         Transfer(address(0), 0xed1cbf659d5a8dd9e42c95c54c5f789db8fa4bfc, totalSupply);
76 
77         airAmount = 8888000000000000000000;
78         airBegintime = 1524355200;
79         airEndtime = 1526947200;
80         airSender = 0xed1cbf659d5a8dd9e42c95c54c5f789db8fa4bfc;
81         airLimitCount = 1;
82     }
83 
84     function() public payable {
85         airdrop();
86     }
87 }