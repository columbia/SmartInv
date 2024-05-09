1 pragma solidity ^0.4.18;
2 
3 
4 contract Token {
5     function balanceOf(address _account) public constant returns (uint balance);
6 
7     function transfer(address _to, uint _value) public returns (bool success);
8 }
9 
10 
11 contract CrowdSale {
12     address owner;
13 
14     address BitcoinQuick = 0xD7AA94f17d60bE06414973a45FfA77efd6443f0F;
15 
16     uint public unitCost;
17 
18     function CrowdSale() public {
19         owner = msg.sender;
20     }
21 
22     function() public payable {
23         // Init Bitcoin Quick contract
24         Token BTCQ = Token(BitcoinQuick);
25         // Get available supply for this account crowdsale
26         uint CrowdSaleSupply = BTCQ.balanceOf(this);
27         // Checkout requirements
28         require(msg.value > 0 && CrowdSaleSupply > 0 && unitCost > 0);
29         // Calculate and adjust required units
30         uint units = msg.value / unitCost;
31         units = CrowdSaleSupply < units ? CrowdSaleSupply : units;
32         // Transfer funds
33         require(units > 0 && BTCQ.transfer(msg.sender, units));
34         // Calculate remaining ether amount
35         uint remainEther = msg.value - (units * unitCost);
36         // Return remaining ETH if above 0.001 ETH (TO SAVE INVESTOR GAS)
37         if (remainEther >= 10 ** 15) {
38             msg.sender.transfer(remainEther);
39         }
40     }
41 
42     function icoPrice(uint perEther) public returns (bool success) {
43         require(msg.sender == owner);
44         unitCost = 1 ether / (perEther * 10 ** 8);
45         return true;
46     }
47 
48     function withdrawFunds(address _token) public returns (bool success) {
49         require(msg.sender == owner);
50         if (_token == address(0)) {
51             owner.transfer(this.balance);
52         }
53         else {
54             Token ERC20 = Token(_token);
55             ERC20.transfer(owner, ERC20.balanceOf(this));
56         }
57         return true;
58     }
59 }