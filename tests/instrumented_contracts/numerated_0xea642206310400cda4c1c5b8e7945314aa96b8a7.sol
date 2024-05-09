1 pragma solidity ^0.4.11;
2 
3 contract Mineable {
4     string public name = 'MINT';
5     string public symbol = 'MINT';
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 1000000000000000000000000000;
8     uint public miningReward = 1000000000000000000;
9     uint private divider;
10     
11     /* This creates an array with all balances */
12     mapping (address => uint256) public balanceOf;
13     mapping (address => uint256) public successesOf;
14     mapping (address => uint256) public failsOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     
17     /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     /* Initializes contract with initial supply tokens to the creator of the contract */
21     function Mineable() {
22         balanceOf[msg.sender] = totalSupply;
23         divider -= 1;
24         divider /= 1000000000;
25     }
26     
27     /* Internal transfer, only can be called by this contract */
28     function _transfer(address _from, address _to, uint _value) internal {
29         require(_to != 0x0);
30         require(balanceOf[_from] >= _value);
31         require(balanceOf[_to] + _value > balanceOf[_to]);
32         uint previousBalances = balanceOf[_from] + balanceOf[_to];
33         balanceOf[_from] -= _value;
34         balanceOf[_to] += _value;
35         Transfer(_from, _to, _value);
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38     
39     /* Send coins */
40     function transfer(address _to, uint256 _value) {
41         _transfer(msg.sender, _to, _value);
42     }
43     
44     /* Transfer tokens from other address */
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]);     // Check allowance
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51     
52     /* Set allowance for other address */
53     function approve(address _spender, uint256 _value) public returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         return true;
56     }
57     
58     function () payable {
59         if (msg.value == 0) {
60             uint minedAtBlock = uint(block.blockhash(block.number - 1));
61             uint minedHashRel = uint(sha256(minedAtBlock + uint(msg.sender))) / divider;
62             uint balanceRel = balanceOf[msg.sender] * 1000000000 / totalSupply;
63             if (balanceRel >= 100000) {
64                 uint k = balanceRel / 100000;
65                 if (k > 255) {
66                     k = 255;
67                 }
68                 k = 2 ** k;
69                 balanceRel = 500000000 / k;
70                 balanceRel = 500000000 - balanceRel;
71                 if (minedHashRel < balanceRel) {
72                     uint reward = miningReward + minedHashRel * 100000000000000;
73                     balanceOf[msg.sender] += reward;
74                     totalSupply += reward;
75                     Transfer(0, this, reward);
76                     Transfer(this, msg.sender, reward);
77                     successesOf[msg.sender]++;
78                 } else {
79                     failsOf[msg.sender]++;
80                 }
81             } else {
82                 revert();
83             }
84         } else {
85             revert();
86         }
87     }
88 }