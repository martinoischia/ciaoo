function [solutions]= postprocessing(femregion,Dati,u_h)
%% [solutions]= postprocessing(femregion,Dati,u_h)
%==========================================================================
% POST PROCESSING OF THE SOLUTION
%==========================================================================
%    called in C_main2D.m
%
%    INPUT:
%          femregion   : (struct)  see create_dof.m
%          Dati        : (struct)  see dati.m
%          uh          : (sparse(ndof,1) real) solution vector
%
%    OUTPUT:
%          solutions   : (struct) containg solution vector uh and
%                        analytical solution u_ex
%

x=femregion.dof(:,1);
y=femregion.dof(:,2);
u_ex=eval(Dati.exact_sol);
sigma_ex(:,1)=eval(Dati.grad_exact_1);
sigma_ex(:,2)=eval(Dati.grad_exact_2);

% plot mesh
figure
plot_mesh(femregion.coord, femregion.connectivity, femregion.domain)


% plot solution with stem -- pointwise visualization
figure
stem3(femregion.dof(:,1),femregion.dof(:,2),u_ex,'-r*');
hold on
stem3(femregion.dof(:,1),femregion.dof(:,2),u_h,'-bo');
legend('Exact Solution', 'Computed solution')
hold off

figure;
x1=femregion.domain(1,1);
x2=femregion.domain(1,2);
y1=femregion.domain(2,1);
y2=femregion.domain(2,2);
M=max(u_h);
m=min(u_h);
if (abs(m-M) < 0.1)
    M=m+1;
end


if Dati.fem == 'P1'
    
    k = 1;
    for ie = 1 : femregion.ne
        trisurf([1 2 3],femregion.dof(k:k+2,1),femregion.dof(k:k+2,2),full(u_h(k:k+2)))
        hold on;
        k=k+3;
    end
elseif Dati.fem == 'P2'
    k = 1;
    for ie = 1 : femregion.ne
        trisurf([1 2 3],femregion.dof([k,k+2,k+4],1),femregion.dof([k,k+2,k+4],2),full(u_h([k,k+2,k+4])))
        hold on;
        k=k+6;
    end   
    
elseif Dati.fem == 'P3'
    k = 1;
    for ie = 1 : femregion.ne
        trisurf([1 2 3],femregion.dof([k,k+3,k+6],1),femregion.dof([k,k+3,k+6],2),full(u_h([k,k+3,k+6])))
        hold on;
        k=k+10;
    end       
end

title('u_h(x,y)'); xlabel('x-axis'); ylabel('y-axis');
axis([x1,x2,y1,y2,m,M]); colorbar;


solutions=struct('u_h',u_h,'u_ex',u_ex);
