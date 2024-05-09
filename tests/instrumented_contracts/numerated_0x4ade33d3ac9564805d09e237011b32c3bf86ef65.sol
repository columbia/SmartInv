1 pragma solidity ^0.4.13;
2 
3 /* Functions from Kitten Coin main contract to be used by sale contract */
4 contract KittenCoin {
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {}
6     function allowance(address owner, address spender) public constant returns (uint256) {}
7 }
8 
9 contract KittenSale {
10     KittenCoin public _kittenContract;
11     address public _kittenOwner;
12     uint256 public totalContributions;
13     uint256 public kittensSold;
14     uint256 public kittensRemainingForSale;
15     
16     function KittenSale () {
17         address c = 0xac2BD14654BBf22F9d8f20c7b3a70e376d3436B4; // set Kitten Coin contract address
18         _kittenContract = KittenCoin(c); 
19         _kittenOwner = msg.sender;
20         totalContributions = 0;
21         kittensSold = 0;
22         kittensRemainingForSale = 0; // set to 0 first as allowance to contract can't be set yet
23     }
24     
25     /* Every time ether is sent to the contract, Kitten Coin will be issued with following rules
26     ** Amount sent < 0.1 ETH - 1 KITTEN for 0.000001 ETH (for example, 0.05 ETH = 50 000 KITTEN)
27     ** 0.1 ETH <= amount sent < 1 ETH - +20% bonus 1.2 KITTEN for 0.000001 ETH (for example, 0.5 ETH = 600 000 KITTEN)
28     ** Amount sent >= 1 ETH - +50% bonus 1.5 KITTEN for 0.000001 ETH (for example, 1.5 ETH = 1 800 000 KITTEN)
29     **
30     ** If not enough KITTEN remaining to sale, transaction will be cancelled.
31     */ 
32     function () payable {
33         require(msg.value > 0);
34         uint256 contribution = msg.value;
35         if (msg.value >= 100 finney) {
36             if (msg.value >= 1 ether) {
37                 contribution /= 6666;
38             } else {
39                 contribution /= 8333;
40             }
41         } else {
42             contribution /= 10000;
43         }
44         require(kittensRemainingForSale >= contribution);
45         totalContributions += msg.value;
46         kittensSold += contribution;
47         _kittenContract.transferFrom(_kittenOwner, msg.sender, contribution);
48         _kittenOwner.transfer(msg.value);
49         updateKittensRemainingForSale();
50     }
51     
52     function updateKittensRemainingForSale () {
53         kittensRemainingForSale = _kittenContract.allowance(_kittenOwner, this);
54     }
55     
56 }