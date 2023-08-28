#include <iostream>
#include <cmath>

using namespace std;

float paraboloid_f(float x, float y) {
    return x*x+y*y;
}

float cos_f(float x, float y) {
    return cos(sqrt(x*x+y*y));
}

float weird_0(float x, float y) {
    return log(x+40)+pow(1.1,y)+x*y/100 - 0.5;
}

float square_0(float x, float y) {
    return cos(0.5*(abs(x)+abs(y))+0.3*sqrt(x*x+y*y))+x*y/100;
}

int main() {
    //float step = 0.3;
    int n_points = 100;
    float PI = 3.1415926535;
    int k = 7;
    float x_min = -k*PI;
    float x_max = k*PI;
    float y_min = -k*PI;
    float y_max = k*PI;
    float x_step = (x_max-x_min)/n_points;
    float y_step = (y_max-y_min)/n_points;

    for(float y = y_min; y < y_max; y+=y_step) {
        for(float x = x_min; x < x_max; x+=x_step) {
            cout << weird_0(x,y)+1 << ", ";
        }
        cout << endl;
    }
}
