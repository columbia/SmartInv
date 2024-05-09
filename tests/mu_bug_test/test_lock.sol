1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.24 <0.6.0;

3 contract testlock {
        
4         uint newLock_previous;
5         uint lock_previous; 
            
6         function test_lock(
7                 uint lock,
8                 uint newLock,
9                 uint amount
10                 ) external {

11                 newLock_previous = newLock; 
12                 lock_previous = lock; 
13                 require(amount >= allLocks[lock].depositAmount, 'wrong amount');
14                 memory config = allLocks[lock];
15                 config.depositAmount = amount;
16                 if(newLock != 0) {
17                     mapLockoToken(newLock, config);
18                 }           
19               }
20  }
