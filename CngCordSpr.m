clear all;
clc;
syms rho theta phi
x = rho*sin(phi)*cos(theta);
y = rho*sin(phi)*sin(theta);
z = rho*cos(phi);
jaco = [diff([x y z],rho);diff([x y z],phi);diff([x y z],theta)];
djaco = det(jaco);
fact = simplify(djaco)