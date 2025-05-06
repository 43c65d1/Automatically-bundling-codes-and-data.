# Automatically-bundling-codes-and-data.

I'm just want to do somthing at my coding life.

这其实没什么好看的，只是改了一下AI的代码（不改实在跑不了）

主要是用来方便我出题的（

打包俩ZIP 一个 0\_std\_*DAYTime\_now*.zip , 一个0\_data\_*DAYTime\_now*.zip

0_std_*.zip 会找 std.cpp、gen.cpp、validator.cpp 打包到 std 文件夹里，然后 把所有的 .in/.out 打到 data 文件夹里。

0_data_*.zip 就只包含 *.in/.out 。

结构大概长这个样：

├── GP.bat
└── Zips/
    ├── 0_std_20231025.zip
    │   ├── std/
    │   │   ├── std.cpp
    │   │   ├── gen.cpp
    │   │   └── validator.cpp
    │   └── data/
    │       ├── 1.in
    │       └── 1.out
    └── 0_Data_20231025.zip
        ├── test1.in
        └── test1.out
