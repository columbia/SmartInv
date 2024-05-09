1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     constructor () public { owner = msg.sender; }
5     address owner;
6 
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11 }
12 
13 contract TokenArtFinity is owned {
14     
15     mapping (address => uint256) balances;
16     mapping (address => mapping (address => uint256)) allowed;
17 
18     string public name = "ArtFinity";    //token name
19     uint8 public decimals = 5;              
20     string public symbol = "AT";           
21     uint256 public totalSupply = 100000000000000; 
22     GoodsTransferInfo[] public goodsTransferArray;
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     
27     struct GoodsTransferInfo {
28         address withDrawAddress;
29         uint32 goodsId;
30         uint32 goodsNum;
31     }
32 
33     constructor () public {
34         balances[msg.sender] = totalSupply; 
35     }
36 
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
39         require(_to != 0x0);
40         balances[msg.sender] -= _value;
41         balances[_to] += _value;
42         emit Transfer(msg.sender, _to, _value);
43         return true;
44     }
45     
46     function transferTokenWithGoods(address goodsWithdrawer, uint256 _value, uint32 goodsId, uint32 goodsNum) public onlyOwner returns (bool success) {
47         
48         require(balances[msg.sender] >= _value && balances[goodsWithdrawer] + _value > balances[goodsWithdrawer]);
49         require(goodsWithdrawer != 0x0);
50         balances[msg.sender] -= _value;
51         balances[goodsWithdrawer] += _value;
52         goodsTransferArray.push(GoodsTransferInfo(goodsWithdrawer, goodsId, goodsNum));
53         emit Transfer(msg.sender, goodsWithdrawer, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58 
59         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
60         balances[_to] += _value;
61         balances[_from] -= _value; 
62         allowed[_from][msg.sender] -= _value;
63         emit Transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) public returns (bool success)   
72     { 
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81     
82     function goodsTransferArrayLength() public constant returns(uint256 length) {
83         return goodsTransferArray.length;
84     }
85 }