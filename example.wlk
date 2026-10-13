class carrera{
  var materias = #{}
  var estudiantes = #{}  
    method materias(){
      return materias
    }
    method agregarMateria(materia){
      materias.add(materia)
      materia.carrera(self)
    }
    method inscribirEstudiante(estudiante){
      estudiantes.add(estudiante)
    }
    method estudiantes(){
      return estudiantes
    }
    method materiasHabilitadasParaEstudiante(estudiante){
      return materias.filter({ materia => estudiante.puedeInscribirseA(materia)})
    }
}
class materia{
  var estudiantes = #{}
  var requisitos = correlativas
  var correlativas = #{}
  var años = 1
  var minimoDeCreditosRequeridos = 0
  var carreraDeLaMateria = carrera
  var creditos = 0
    method inscribirEstudiante(estudiante){
      estudiantes.add(estudiante)
    }
    method carrera(_carrera){
      carreraDeLaMateria = _carrera
    }
    method carrera(){
      return carreraDeLaMateria
    }
    method correlativas(_correlativa) {
      correlativas.add(_correlativa)
    }
    method correlativas(){
      return correlativas
    }
    method requisito(_requisito){
      requisitos = _requisito
    }
    method estudiantes(){
      return estudiantes
    }
    method añoDeLaMateria(_año){
      años = _año
    }
    method años(){
      return años
    }
    method cumpleRequisito(estudiante) {
      return requisitos.cumpleRequisito(self, estudiante)
    }
    method minimoDeCreditosRequeridos(_cantidad) {
      minimoDeCreditosRequeridos = _cantidad
    }
    method minimoDeCreditosRequeridos() {
      return minimoDeCreditosRequeridos
    }
    method creditos(){
      return creditos
    }
    method agregarCreditosQueDaLaMateria(cantidad){
      creditos = cantidad
    }
}
object correlativas{
  method cumpleRequisito(materia, estudiante){
   return materia.correlativas().all({ requisito => estudiante.tieneAprobada(requisito)}) 
    }
}
object creditos{
  method cumpleRequisito(materia, estudiante){
    return estudiante.cantidadDeCreditosEn(materia.carrera()) >= materia.minimoDeCreditosRequeridos()
  }
}
object sinRequisitos{
  method cumpleRequisito(materia, estudiante){
    return true
  }
}
object porAños {
  method cumpleRequisito(materia, estudiante){
    return estudiante.aprobeTodasLasDelAaño(materia)
  }
}

class estudiante{
  var nombre = ""
  var materiasQueCurso = #{}  
  var carrerasQueCurso = #{}
  var historial = ""
  var creditosParaMaterias = 0 
    method cantidadDeCreditos(){
      return creditosParaMaterias
    } 
    method nombre(){
      return nombre
    }
    method inscribirmeAMateria(materia){
      self.validarQueNoEsteIncriptoALaMateria(materia)
      self.validarQueLaMateriaNoEsteAprobada(materia)
      self.validarSiLaMateriaEsDeMisCarreras(materia)
      self.validarQueTengaAprobadoSusRequisitos(materia)
      materia.inscribirEstudiante(self)
      materiasQueCurso.add(materia) 
    }
    method validarQueNoEsteIncriptoALaMateria(materia){
      if ( self.estaInscriptoAMateria(materia) )
        {self.error("ya esta inscripto a la materia")}
    }
    method validarQueLaMateriaNoEsteAprobada(materia){
      if (self.tieneAprobada(materia)) 
        {self.error("la materia ya esta aprobada")}
    }
    method validarSiLaMateriaEsDeMisCarreras(materia){
      if(not self.materiaEsDeMisCarreras(materia))
        {self.error("la materia no corresponde a mis carreras")}
    }
    method validarQueTengaAprobadoSusRequisitos(materia){
      if(not self.tengoAprobadoSusCorrelativa(materia)) 
        {self.error("no tiene aprobo los requisitos")}
    }
    method inscribirmeACarrera(_carrera){
      _carrera.inscribirEstudiante(self)
      carrerasQueCurso.add(_carrera)
    }
    method carrerasInscriptas() {
      return carrerasQueCurso
    }
    method materiasInscriptas(){
      return materiasQueCurso
    }
    method materiasDeMisCarreras(){
      return carrerasQueCurso.map({_carrera => _carrera.materias()})
    }
    method materiaEsDeMisCarreras(materia) {
      return carrerasQueCurso.any({carrera => carrera.materias().contains(materia)})
    }
    method agregarHistorial(_historialAcademico){
      historial = _historialAcademico
    }
    method historial(){
      return historial
    }
    method registrarCursada(_cursada){
      self.validarNotaDeLaCursada(_cursada)
      self.validarSiYaEstaAprobada(_cursada)
      self.cursadaEsDeMisCarreras(_cursada)
      historial.registrarCursada(_cursada)
    }
    method validarNotaDeLaCursada(_cursada){
      if (_cursada.nota() < 1 || _cursada.nota() > 10 ) 
        {self.error("la nota debe estar entre 1 y 10")}
    }
    method validarSiYaEstaAprobada(_cursada){
      if (historial.tieneAprobada(_cursada.materia()))
        {self.error("ya aprobe esa materia")}
    }
    method cursadaEsDeMisCarreras(_cursada){
      if (not (self.materiaEsDeMisCarreras(_cursada.materia()))) 
        {self.error("esta materia no es parte de mis carreras")}
    }
    method cantidadAprobadasEn(_carrera) {
      return historial.cantidadAprobadasEn(_carrera)
    }
    method promedioAprobadasEn(_carrera) {
      return historial.promedioAprobadasEn(_carrera)
    }
    method cantidadAprobadas() {
      return historial.cantidadAprobadas()
    }
    method promedioAprobadas() {
      return historial.promedioAprobadas()
    }
    method cursadasDe(materia) {
      return historial.cursadasDe(materia)
    }
    method tieneAprobada(materia){
      return historial.tieneAprobada(materia)
    }
    method estaInscriptoAMateria(materia){
      return materiasQueCurso.contains(materia)
    }
    method tengoAprobadoSusCorrelativa(materia){
      return materia.cumpleRequisito(self)
    }
    method puedeInscribirseA(materia) {
  return (self.materiaEsDeMisCarreras(materia) && 
      not self.tieneAprobada(materia) && 
      not self.estaInscriptoAMateria(materia) && 
          self.tengoAprobadoSusCorrelativa(materia))
    }
    method materiasHabilitadasEnCarrera(_carrera){
      return _carrera.materiasHabilitadasParaEstudiante(self)
    }
    method aprobeTodasLasDelAaño(materia){
      return materia.carrera().materias().filter({ unaMateria => unaMateria.años() == materia.años() - 1}).all({ materiaAnterior =>self.tieneAprobada(materiaAnterior)})
    }
    method cantidadDeCreditosEn(_carrera) {
      return _carrera.materias().filter({ unaMateria => self.tieneAprobada(unaMateria) }).sum({ unaMateria => unaMateria.creditos() })
    }
}
class historialAcademico {
  const cursadas = []

  method registrarCursada(cursada) {
    cursadas.add(cursada)
  }
  method todasLasCursadas() {
    return cursadas
  }
  method cursadasDe(materia) {
    return cursadas.filter({ cursada =>cursada.materia() == materia})
  }
  method tieneAprobada(materia) {
    return self.cursadasDe(materia).any({ cursada =>cursada.estaAprobada()})
  }
  method cursadasAprobadasEn(carrera) {
    return cursadas.filter({ unaCursada => carrera.materias().contains(unaCursada.materia()) && unaCursada.estaAprobada()})
  }
  method cantidadAprobadasEn(carrera) {
    return self.cursadasAprobadasEn(carrera).size()
  }
  method sumaNotasAprobadasEn(carrera) {
    return self.cursadasAprobadasEn(carrera).sum({ unaCursada => unaCursada.nota()})
  }
  method promedioAprobadasEn(carrera) {
    return self.sumaNotasAprobadasEn(carrera) /self.cantidadAprobadasEn(carrera)
  }
  method cursadasAprobadas() {
    return cursadas.filter({ unaCursada => unaCursada.estaAprobada()})
  }
  method cantidadAprobadas() {
    return self.cursadasAprobadas().size()
  }
  method promedioAprobadas() {
    return self.cursadasAprobadas().sum({ unaCursada => unaCursada.nota()}) / self.cantidadAprobadas()
  }
}

class cursada{
  var nota = 0
  var materia = ""
    method nota(_nota){
      nota = _nota
    }
    method nota(){
      return nota
    }
    method materia(_materia){
      materia = _materia
    }
    method materia(){
      return materia
    }
    method estaAprobada(){
      return nota >= 6
    }
}