1 pragma solidity ^0.5.0;
2 
3 /**
4  * The ERC20 multi sender Contract
5  * Useful to do multiple transfers of the same token to different addresses
6  * 
7  * @author Fabio Pacchioni <mailto:fabio.pacchioni@gmail.com>
8  * @author Marco Vasapollo <mailto:ceo@metaring.com>
9  */
10 
11 contract ERC20 {
12     function transferFrom(address from, address to, uint256 value) public returns (bool) {}
13 }
14 
15 contract MultiSender {
16     
17     /**
18      * @param _tokenAddr the address of the ERC20Token
19      * @param _to the list of addresses that can receive your tokens
20      * @param _value the list of all the amounts that every _to address will receive
21      * 
22      * @return true if all the transfers are OK.
23      * 
24      * PLEASE NOTE: Max 150 addresses per time are allowed.
25      * 
26      * PLEASE NOTE: remember to call the 'approve' function on the Token first,
27      * to let MultiSender be able to transfer your tokens.
28      */
29     function multiSend(address _tokenAddr, address[] memory _to, uint256[] memory _value) public returns (bool _success) {
30         assert(_to.length == _value.length);
31         assert(_to.length <= 150);
32         ERC20 _token = ERC20(_tokenAddr);
33         for (uint8 i = 0; i < _to.length; i++) {
34             assert((_token.transferFrom(msg.sender, _to[i], _value[i])) == true);
35         }
36         return true;
37     }
38 }