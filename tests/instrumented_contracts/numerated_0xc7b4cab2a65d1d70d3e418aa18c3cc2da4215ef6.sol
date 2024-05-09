1 pragma solidity ^0.4.15;
2 
3 contract ThanahCoin {
4     
5     event Transfer(address indexed from, address indexed to, uint256 value);
6 
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10 
11     uint public totalSupply;
12     uint public availableSupply;
13     mapping (address => uint256) public balanceOf;
14 
15     uint private lastBlock;    
16     uint private coinsPerBlock;
17 
18     function ThanahCoin() {
19         name = "ThanahCoin";
20         symbol = "THC";
21         decimals = 0;
22         lastBlock = block.number;
23         totalSupply = 0;
24         availableSupply = 0;
25         coinsPerBlock = 144;
26     }
27 
28     function transfer(address _to, uint256 _value) {
29         
30         require(balanceOf[msg.sender] >= _value);
31         require(balanceOf[_to] + _value >= balanceOf[_to]);
32 
33         balanceOf[msg.sender] -= _value;
34         balanceOf[_to] += _value;
35 
36         Transfer(msg.sender, _to, _value);
37 
38     }
39 
40     function issue(address _to) {
41 
42         _mintCoins();
43 
44         uint issuedCoins = availableSupply / 100;
45 
46         availableSupply -= issuedCoins;
47         balanceOf[_to] += issuedCoins;
48 
49         Transfer(0, _to, issuedCoins);
50 
51     }
52 
53     function _mintCoins() internal {
54 
55         uint elapsedBlocks = block.number - lastBlock;
56         lastBlock = block.number;
57 
58         uint mintedCoins = elapsedBlocks * coinsPerBlock;
59 
60         totalSupply += mintedCoins;
61         availableSupply += mintedCoins;
62 
63     }
64 }