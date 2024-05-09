1 pragma solidity >=0.4.22;
2 
3 /*
4 * Hello world!
5 */
6 
7 contract SendMeBeer {
8     address payable myAddress = 0xE52497FCA47cA80F6eAa161A80c0FAd247DDb457;
9     function () external payable {
10         myAddress.transfer(msg.value);
11     }
12     function getAddress() public view returns(address) {
13         return myAddress;
14     }
15 }