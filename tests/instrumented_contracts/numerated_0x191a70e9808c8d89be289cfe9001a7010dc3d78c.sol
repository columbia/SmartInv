1 pragma solidity ^0.4.21;
2 
3 contract HFCoin {
4     string public name;
5     string public symbol;
6     address public owner;
7     uint256 public prizeAmount = 0;
8     bool public gameStarted = false;
9     bool public prizeWon = false;
10 
11     mapping (address => uint256) public balanceOf;
12     
13     event Burn(address indexed from, uint256 value);
14     event Redemption(address indexed from, uint256 value);
15     event TokenRequest(address indexed from, uint256 value);
16     event Winner(address indexed from);
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function HFCoin(
24         string tokenName,
25         string tokenSymbol
26     ) public 
27     {
28         balanceOf[msg.sender] = 0;
29         name = tokenName;
30         symbol = tokenSymbol;
31         owner = msg.sender;
32     }
33 
34     function burn(uint256 _value) public returns (bool success) {
35         require(_value <= 10);
36         balanceOf[msg.sender] -= _value;
37         emit Burn(msg.sender, _value);
38         return true;
39     }
40 
41     function _redeem(address _from, uint256 _value) internal {
42         require(balanceOf[_from] >= _value);
43         require(balanceOf[owner] + _value > balanceOf[owner]);
44         require(_value <= 1337);
45 
46         balanceOf[_from] -= _value;
47         balanceOf[owner] += _value;
48         emit Redemption(_from, _value);
49 
50         if (_value == 1337 && gameStarted && !prizeWon) {
51             prizeWon = true;
52             emit Winner(_from);
53             _from.transfer(prizeAmount);
54         }
55     }
56 
57     function redeem(uint256 _value) public {
58         _redeem(msg.sender, _value);
59     }
60 
61     function _requestTokens(address _to, uint256 _value) internal {
62         require(balanceOf[_to] + _value <= 10);
63         balanceOf[_to] += _value;
64         emit TokenRequest(_to, _value);  
65     }
66 
67     function requestTokens(uint256 _value) public {
68         _requestTokens(msg.sender, _value);
69     }
70 
71     function prizeDeposit() public onlyOwner payable {}
72 
73     function startGame(uint256 _prizeAmount) public onlyOwner {
74         prizeAmount = _prizeAmount;
75         gameStarted = true;
76     }
77 
78     function gameOver() public onlyOwner {
79         selfdestruct(owner);
80     }
81 }