function [P, t, normals, T] = meshvolume(P, t, grade)
%   Outputs a combined volume/surface mesh based on the surface CAD mesh
%   grade (refinement index) varies depending on geometry
%   P - all nodes
%   t - surface facets
%   n - normal vectors 
%   T - tetrahedra
%   Important: nodes of surface facets are automatically placed up front
%   Uses PDE toolbox
%
%   SNM 2018-2021
    TR          = triangulation(t, P);  %   in mm
    stlwrite(TR, 'temp.stl');
    model       = createpde(1);
    importGeometry(model, 'temp.stl');
    TetMesh     = generateMesh(model, 'GeometricOrder', 'linear', 'Hmax', grade); 
    P           = TetMesh.Nodes';
    T           = TetMesh.Elements';
    TR          = triangulation(T, P);
    t           = freeBoundary(TR);
    normals     = meshnormals(P, t);
    %   Fix triangle orientation (just in case, optional)
    t           = meshreorient(P, t, normals);
end
