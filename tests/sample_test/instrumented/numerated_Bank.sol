1 1 pragma solidity ^0.5.0;
2 
3 2 contract Bank{
4 
5 
6 3 //reentrant here 
7 4     function work(uint256 id, address goblin, uint256 loan, uint256 maxReturn, bytes calldata data)
8 5         external payable
9 6         onlyEOA accrue(msg.value)
10 7     {
11 8         // 1. Sanity check the input position, or add a new position of ID is 0.
12 9         if (id == 0) {
13 10             id = nextPositionID++;
14 11             positions[id].goblin = goblin;
15 12             positions[id].owner = msg.sender;
16 13         } else {
17 14             require(id < nextPositionID, "bad position id");
18 15         }
19 16         emit Work(id, loan);
20 17         // 2. Make sure the goblin can accept more debt and remove the existing debt.
21 18         uint256 debt = _removeDebt(id).add(loan);
22 19         // 3. Perform the actual work, using a new scope to avoid stack-too-deep errors.
23 20         uint256 back;
24 21         {
25 22             uint256 sendETH = msg.value.add(loan);
26 23             uint256 beforeETH = address(this).balance.sub(sendETH);
27 24             Goblin(goblin).work.value(sendETH)(id, msg.sender, debt, data);
28 25             back = address(this).balance.sub(beforeETH);
29 26         }
30 27         // 4. Check and update position debt.
31 28         uint256 lessDebt = Math.min(debt, Math.min(back, maxReturn));
32 29         debt = debt.sub(lessDebt);
33 30         if (debt > 0) {
34 31             require(debt >= config.minDebtSize(), "too small debt size");
35 32             uint256 health = Goblin(goblin).health(id);
36 33             uint256 workFactor = config.workFactor(goblin, debt);
37 34             _addDebt(id, debt);
38 35         }
39 36         // 5. Return excess ETH back.
40 37         if (back > lessDebt) SafeToken.safeTransferETH(msg.sender, back - lessDebt);
41 38     }
42 39 }