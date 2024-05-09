1 pragma solidity ^0.4.19;
2 
3 contract Snake {
4     address public ownerAddress;
5     uint256 public length; // stores length of the snake
6 
7     mapping (uint256 => uint256) public snake; // stores prices of the tokens
8     mapping (uint256 => address) public owners; // stoes owners of the tokens
9     mapping (uint256 => uint256) public stamps; // timestamps of last trades of tokens
10     
11     event Sale(address owner, uint256 profit, uint256 stamp); // 'stores' sales of tokens
12     
13     function Snake() public {
14         ownerAddress = msg.sender; 
15         length = 0; // set initial length of the snake to 0
16         _extend(length); // create head of the snake
17     }
18     
19     // this function is called when someone buys a token from someone else
20     function buy(uint256 id) external payable {
21         require(snake[id] > 0); // must be a valid token
22         require(msg.value >= snake[id] / 100 * 150); // must send enough ether to buy it
23         address owner = owners[id];
24         uint256 amount = snake[id];
25 
26         snake[id] = amount / 100 * 150; // set new price of token
27         owners[id] = msg.sender; // set new owner of token
28         stamps[id] = uint256(now); // set timestamp of last trade of token to now
29 
30         owner.transfer(amount / 100 * 125); // transfer investment+gain to previous owner. 
31         Sale(owner, amount, uint256(now)); // broadcast Sale event to the 'chain
32         // if this is the head token being traded:
33         if (id == 0) { 
34             length++; // increase the length of the snake
35             _extend(length); // create new token
36         }
37         ownerAddress.transfer(this.balance); // transfer remnant to contract owner, no ether should be stored in contract
38     }
39     // get price of certain token for UI purposes
40     function getToken(uint256 id) external view returns(uint256, uint256, address) {
41         return (snake[id] / 100 * 150, stamps[id], owners[id]);
42     }
43     // increases length of the snake
44     function _extend(uint256 id) internal {
45         snake[id] = 1 * 10**16;
46         owners[id] = msg.sender;
47     }
48 }