1 pragma solidity ^0.4.10;
2 /*
3       No more panic sells.
4       Force yourself to hodl them eths with HodlBox!
5 */
6 
7 contract HodlBox {
8 
9   uint public hodlTillBlock;
10   address public hodler;
11   uint public hodling;
12   bool public withdrawn;
13 
14   event HodlReleased(bool _isReleased);
15   event Hodling(bool _isCreated);
16 
17   function HodlBox(uint _blocks) payable {
18     hodler = msg.sender;
19     hodling = msg.value;
20     hodlTillBlock = block.number + _blocks;
21     withdrawn = false;
22     Hodling(true);
23   }
24 
25   function deposit() payable {
26     hodling += msg.value;
27   }
28 
29   function releaseTheHodl() {
30     // Only the contract creator can release funds from their HodlBox,
31     // and only after the defined number of blocks has passed.
32     if (msg.sender != hodler) throw;
33     if (block.number < hodlTillBlock) throw;
34     if (withdrawn) throw;
35     if (hodling <= 0) throw;
36     withdrawn = true;
37     hodling = 0;
38 
39     // Send event to notifiy UI
40     HodlReleased(true);
41 
42     selfdestruct(hodler);
43   }
44 
45   // constant functions do not mutate state
46   function hodlCountdown() constant returns (uint) {
47     var hodlCount = hodlTillBlock - block.number;
48     if (block.number >= hodlTillBlock) {
49       return 0;
50     }
51     return hodlCount;
52   }
53 
54   function isDeholdable() constant returns (bool) {
55     if (block.number < hodlTillBlock) {
56       return false;
57     } else {
58       return true;
59     }
60   }
61 
62 }