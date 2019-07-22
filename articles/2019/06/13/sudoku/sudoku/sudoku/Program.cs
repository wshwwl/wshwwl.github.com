using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sudoku
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Diagnostics.Stopwatch sw = new System.Diagnostics.Stopwatch();
            while (true)
            {
                string input = Console.ReadLine();
                sw.Restart();
                Sudoku a = new Sudoku(input);
                a.Solve();
                Console.WriteLine(a);
                sw.Stop();
                Console.WriteLine("用时：" + sw.ElapsedMilliseconds);
            }
        }

    }
}
