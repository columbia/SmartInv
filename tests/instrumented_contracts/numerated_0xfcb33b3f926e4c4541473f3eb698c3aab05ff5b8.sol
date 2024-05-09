1 pragma solidity ^0.4.21;
2 
3 contract FangTangCoin {
4     string public name;
5     string public symbol;
6     uint256 public decimals;
7     uint256 public totalSupply;
8     
9     address public creator;
10     
11     bool public autoSend = false;
12     uint public start;
13     uint public end;
14     uint public rate;
15     uint public freeCount;
16     
17     mapping (address => uint256) public balanceOf;
18     mapping (address => uint8) public buyCountOf;
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // buy token 
22     function () public payable {
23         require(autoSend);
24         require(now >= start && now <= end);
25         
26         uint256 weiAmount = msg.value;
27         uint256 tokens;
28         if (rate == 0) 
29             tokens = freeCount*decimals;
30         else 
31             tokens = (weiAmount/1000000000000000000)*rate;
32         
33         require(tokens > 0);
34         
35         // 不要自己提到自己账户
36         require(creator != msg.sender);
37 
38         // 首先检查发token的账户是否拥有对应数量的代币 
39         require(balanceOf[creator] >= tokens);
40         
41 
42 
43         // 当 rate 为 0 时，检查是否已经领取过
44         if (rate == 0)
45             require(buyCountOf[msg.sender] < 1);
46             
47         // 开始转移代币
48         uint previousBalances = balanceOf[msg.sender] + balanceOf[creator];
49         balanceOf[msg.sender] += tokens;
50         balanceOf[creator] -= tokens;
51         
52         // 这个是事件
53         emit Transfer(creator,msg.sender, tokens);
54         assert(balanceOf[msg.sender] + balanceOf[creator] == previousBalances);
55         
56          if (rate == 0) 
57             buyCountOf[msg.sender] += 1;
58         
59     }
60     
61     function getETH() public {
62         require(address(this).balance > 0 && msg.sender == creator);
63         creator.transfer(address(this).balance);
64     }
65     
66     function FangTangCoin( 
67         uint256 initialSupply,
68         string tokenName,
69         string tokenSymbol,
70         uint8 tokenDecimals,
71         bool tokenAutoSend,
72         uint tokenStart,
73         uint tokenEnd,
74         uint tokenPrice,
75         uint tokenFreeCount
76     ) public payable
77     {
78         name = tokenName;                       
79         symbol = tokenSymbol; 
80         decimals = tokenDecimals;
81         
82         creator = msg.sender;
83         totalSupply = initialSupply * ( 10 ** uint256(decimals) ); 
84         balanceOf[msg.sender] = totalSupply;
85         
86         autoSend = tokenAutoSend;
87         start = tokenStart;
88         end = tokenEnd;
89         rate = tokenPrice;
90         freeCount = tokenFreeCount;
91         
92         
93     }
94     
95     function transfer(address _to, uint256 _value) public {
96         
97         // _value = _value * ( 10 ** uint256(decimals) );
98         
99         require(_to != 0x0);
100         require(msg.sender != _to);
101         
102         require(balanceOf[msg.sender] >= _value);
103         require(balanceOf[_to] + _value > balanceOf[_to]);
104         
105         uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];
106         balanceOf[msg.sender] -= _value;
107         balanceOf[_to] += _value;
108         
109         // 这个是事件
110         emit Transfer(msg.sender, _to, _value);
111         assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
112     }
113     
114     
115 
116 }