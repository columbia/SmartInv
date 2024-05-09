1 pragma solidity ^0.4.11;
2 
3 contract DMINT {
4     string public name = 'DMINT';
5     string public symbol = 'DMINT';
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 1000000000000000000000000000;
8     uint public miningReward = 1000000000000000000;
9     uint private divider;
10     uint private randomNumber;
11     
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     mapping (address => uint256) public successesOf;
15     mapping (address => uint256) public failsOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     
18     /* This generates a public event on the blockchain that will notify clients */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     
21     /* Initializes contract with initial supply tokens to the creator of the contract */
22     function DMINT() public {
23         balanceOf[msg.sender] = totalSupply;
24         divider -= 1;
25         divider /= 1000000000;
26     }
27     
28     /* Internal transfer, only can be called by this contract */
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value > balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39     
40     /* Send coins */
41     function transfer(address _to, uint256 _value) external {
42         _transfer(msg.sender, _to, _value);
43     }
44     
45     /* Transfer tokens from other address */
46     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);     // Check allowance
48         allowance[_from][msg.sender] -= _value;
49         _transfer(_from, _to, _value);
50         return true;
51     }
52     
53     /* Set allowance for other address */
54     function approve(address _spender, uint256 _value) external returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58     
59     function () external payable {
60         if (msg.value == 0) {
61             randomNumber += block.timestamp + uint(msg.sender);
62             uint minedAtBlock = uint(block.blockhash(block.number - 1));
63             uint minedHashRel = uint(sha256(minedAtBlock + randomNumber + uint(msg.sender))) / divider;
64             uint balanceRel = balanceOf[msg.sender] * 1000000000 / totalSupply;
65             if (balanceRel >= 100000) {
66                 uint k = balanceRel / 100000;
67                 if (k > 255) {
68                     k = 255;
69                 }
70                 k = 2 ** k;
71                 balanceRel = 500000000 / k;
72                 balanceRel = 500000000 - balanceRel;
73                 if (minedHashRel < balanceRel) {
74                     uint reward = miningReward + minedHashRel * 100000000000000;
75                     balanceOf[msg.sender] += reward;
76                     totalSupply += reward;
77                     Transfer(0, this, reward);
78                     Transfer(this, msg.sender, reward);
79                     successesOf[msg.sender]++;
80                 } else {
81                     failsOf[msg.sender]++;
82                 }
83             } else {
84                 revert();
85             }
86         } else {
87             revert();
88         }
89     }
90 }