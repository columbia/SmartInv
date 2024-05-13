1 pragma solidity ^0.5.16;
2 
3 contract Denominations {
4     address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
5     address public constant BTC = 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB;
6 
7     // Fiat currencies follow https://en.wikipedia.org/wiki/ISO_4217
8     address public constant USD = address(840);
9     address public constant GBP = address(826);
10     address public constant EUR = address(978);
11     address public constant JPY = address(392);
12     address public constant KRW = address(410);
13     address public constant CNY = address(156);
14     address public constant AUD = address(36);
15     address public constant CAD = address(124);
16     address public constant CHF = address(756);
17     address public constant ARS = address(32);
18     address public constant PHP = address(608);
19     address public constant NZD = address(554);
20     address public constant SGD = address(702);
21     address public constant NGN = address(566);
22     address public constant ZAR = address(710);
23     address public constant RUB = address(643);
24     address public constant INR = address(356);
25     address public constant BRL = address(986);
26 }
