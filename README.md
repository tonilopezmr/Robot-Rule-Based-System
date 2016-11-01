# Robot-Rule-Based-System


We have a robot, several lampposts with blown bulbs and a bulb warehouse, lying on a grid as shown in Figure 1. Each lamppost may have several blown bulbs. The objective is that the robot loads bulbs at the warehouse to replace blown bulbs. The robot must not carry bulbs when all blown bulbs have been replaced.

An example of this initial state is shown in Figure 1. The robot and the warehouse can be located anywhere on the grid; the number of lampposts, their location as well as the number of blown bulbs in each lamppost can be different for a given initial state. The size of the grid can be defined for a given initial state.

The solution to this problem does not need to represent the number of bulbs in each lamppost, only those that have blown. In Figure 1, there are three lampposts with 3, 2 and 2 blown bulbs.

The robot can only move horizontally and vertically, at each movement the robot moves from one cell to the next. There is a maximum number of bulbs the robot can carry. That maximum number of bulbs is the maximum number of blown bulbs in a lamppost at the initial state. For example in Figure 1, the maximum number of bulbs that the robot can carry is 3.

When the robot is at the warehouse, it can load several bulbs without exceeding the maximum number of bulbs. The loading operation must be performed with a single rule loading all bulbs needed at the same time. Bulbs cannot be loaded one by one.

When the robot arrives to a lamppost with blown bulbs, it will be able to fix the lamppost if it is carrying at least as many bulbs as blown bulbs. The replacement of all the blown bulbs in a lamppost is performed with a single rule. It is not possible to replace only some of the blown bulbs in a lamppost, all of them must be replaced at the same time. For example, in Figure 1, the lamppost in cell (4,2) has 2 blown bulbs, so if the robot is carrying 2 or 3 bulbs, then it will replace all blown bulbs with a single rule.

The cost of each movement over the grid, and loading/replacing all bulbs is 1.
