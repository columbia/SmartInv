1 pragma solidity ^0.4.18;
2 /*
3  * A good friend of mine has been fired from his job just before christmas, in December 2017.
4  * Since then, he has been looking for a new job, but wasn't successful due to difficult state of
5  * labor market in Czech Republic. This is just another one of my futile attempts to help him.
6  *
7  * If you have some spare Ethereum, please consider donating to help him in this difficult life situation
8 */
9 contract Charity_For_My_Friend{
10     address owner;
11     
12     function Charity_For_My_Friend() {
13         owner = msg.sender;
14     }
15     
16     function kill() {
17         require(msg.sender == owner);
18         selfdestruct(owner);
19     }
20     
21     function () payable {}
22 }