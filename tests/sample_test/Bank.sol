1 pragma solidity ^0.5.0;

2 contract Bank{


3 //reentrant here 
4     function work(uint256 id, address goblin, uint256 loan, uint256 maxReturn, bytes calldata data)
5         external payable
6         onlyEOA accrue(msg.value)
7     {
8         // 1. Sanity check the input position, or add a new position of ID is 0.
9         if (id == 0) {
10             id = nextPositionID++;
11             positions[id].goblin = goblin;
12             positions[id].owner = msg.sender;
13         } else {
14             require(id < nextPositionID, "bad position id");
15         }
16         emit Work(id, loan);
17         // 2. Make sure the goblin can accept more debt and remove the existing debt.
18         uint256 debt = _removeDebt(id).add(loan);
19         // 3. Perform the actual work, using a new scope to avoid stack-too-deep errors.
20         uint256 back;
21         {
22             uint256 sendETH = msg.value.add(loan);
23             uint256 beforeETH = address(this).balance.sub(sendETH);
24             Goblin(goblin).work.value(sendETH)(id, msg.sender, debt, data);
25             back = address(this).balance.sub(beforeETH);
26         }
27         // 4. Check and update position debt.
28         uint256 lessDebt = Math.min(debt, Math.min(back, maxReturn));
29         debt = debt.sub(lessDebt);
30         if (debt > 0) {
31             require(debt >= config.minDebtSize(), "too small debt size");
32             uint256 health = Goblin(goblin).health(id);
33             uint256 workFactor = config.workFactor(goblin, debt);
34             _addDebt(id, debt);
35         }
36         // 5. Return excess ETH back.
37         if (back > lessDebt) SafeToken.safeTransferETH(msg.sender, back - lessDebt);
38     }
39 }